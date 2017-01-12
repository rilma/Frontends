;
;
;
;By Ronald Ilma
;
; 28 May 2003
;
;
PRO DENSITY_DPS, 			$
	filename=filename,		$
	tablepath=tablepath,	$
	figfilen=figfilen,		$
	t0=t0, 					$
	tf=tf, 					$
	pp=pp, 					$
	ionosonde=ionosonde

	IF N_ELEMENTS(filename) EQ 0 THEN filename = '../../../onedayfiles/density_dps/last.TXT'
	IF N_ELEMENTS(tablepath) EQ 0 THEN tablepath = '../../colortable/'
	IF N_ELEMENTS(figfilen) EQ 0 THEN figfilen = '/dev/stdout'
	IF N_ELEMENTS(pp) EQ 0 THEN pp = 1
	IF N_ELEMENTS(ut) EQ 0 THEN ut = 1
	IF N_ELEMENTS(par) EQ 0 THEN par = 0
	IF N_ELEMENTS(t0) EQ 0 THEN t0 = 0
	IF N_ELEMENTS(tf) EQ 0 THEN tf = 23.98
	IF N_ELEMENTS(ionosonde) EQ 0 THEN ionosonde = 0

	newpar = {newppp,xsize:6.0,ysize:4.0,xoffset:1.25,yoffset:3.50}
	newpp = 4

	hrange = [0,10000.]

	READ_DENSITY_DPS_ASCII, file_open=filename, param=param, hei=hei, time=time

	rdata = 1.24 * 1.e10 * param * param 				;frecuency to density
	rtime = (ut EQ 0) ? time - 5*3600l : time
	ss = TO_TIME(rtime(0))

	xrange = [TO_INT(ss(0),ss(1),t0), TO_INT(ss(0),ss(1),tf)]
	tvalid = WHERE(rtime LE xrange(1) AND rtime GE xrange(0),ctvalid)

	xx = MAKE_X(xrange,/EXACT)
	t0 = xrange(0)
	xx.range=xx.range-t0
	xx.tickv = xx.tickv-t0
	xfn = rtime-t0

	ratio_th = 1.5
	IF N_ELEMENTS(low_th) EQ 0 THEN low_th = [1000.,2*1.e12]
	rdata = CLEAN_ISR(rdata*1.0,hei=hei,low_th=low_th,ratio_th=ratio_th)

	zfn = 10*ALOG10(rdata)

	mincol = 10
	maxcol = 39
	maxlev = 130
	minlev = 90
	makeformat = '(E9.2)'
	title = 'DPS electron density over Jicamarca (m!E-3!N)'
	title1 = 'Maximum F region Density'
	ytitle1 = 'm!E-3!N'

	hvalid = WHERE(hei GE hrange(0) AND hei LE hrange(1),chvalid)
	zfn = zfn(*,hvalid)
	hei = hei(hvalid)
	yrange = [MIN(hei), MAX(hei)]
	oldxtitle = (ut EQ 0) ? 'Local Time: ' : 'Universal Time: '
	ytitle = 'Altitude (km)'
	oldxtitle = oldxtitle+xx.title

	nplots = 1

	xsize = 700
	ysize = 350*nplots
	oldpp = pp
	CONTROL_PLOT,pp=pp,CLOSE=0,FILENAME=figfilen,newpar=newpar,newpp=newpp, TABLEPATH=tablepath
	IF pp EQ 100 THEN DEVICE,SET_RESOLUTION=[xsize,ysize]
	IF pp EQ 1 OR pp GT 10 AND pp LT 100 THEN Window, /FREE, XSIZE=xsize, ysize=ysize

	!P.MULTI = [0,1,nplots,0,0]

	charsize = 0.75
	gaps = FINDGAPS(xfn(tvalid),ngaps)
	xmargin = [10,15]
	ymargin = !Y.MARGIN
	xtickn=xx.tickn
	xtitle = oldxtitle
	IF nplots EQ 2 THEN BEGIN
		ymargin = [-4,!Y.MARGIN(1)]
		ymargin1 = [!Y.MARGIN(0),7]
		xtickn = REPLICATE(' ',30)
		xtitle = ' '
	ENDIF
	nlev = 29.
	col=BYTE(CEIL(FINDGEN(nlev)/(nlev)*(maxcol-mincol)+mincol))
	lev = FINDGEN(nlev)/(nlev-1)*(maxlev-minlev)+minlev

	CONT_IMAGE,zfn(tvalid,*),xfn(tvalid),hei,$
		C_COLORS=col*1.0,resize = 1,$
		maxa=maxlev,mina=minlev,$
		ngaps=ngaps,gaps=gaps,$
		nlev=nlev,$
		yrange = yrange,YSTYLE=1,$
		CHARSIZE=charsize,YTITLE=ytitle,$
		TITLE = title,$
		xtitle = xtitle,$
		XRANGE = xx.range,XSTYLE=1,$
		XTICKS=xx.ticks,xtickn=xtickn ,$
		XMINOR=xx.minor,XTICKV=xx.tickv,$
		BOTTOM = mincol, TOP=maxcol,$
		XMARGIN=xmargin,ymargin=ymargin,$
		XGRIDSTYLE=1,XTICKLEN=0.5,$
		YGRIDSTYLE=1,YTICKLEN=0.5,novalid_col = !P.COLOR

;************************************************************************************
	IF ionosonde EQ 1 THEN  BEGIN
		yfn0_b = GET_DIGISONDE(time=dtime,trange=xrange,dpath=dps_path,var=1)
		yfn1_b = GET_DIGISONDE(time=dtime,trange=xrange,dpath=dps_path,var=2)
		xfn_b = dtime-t0
	ENDIF
 	IF N_ELEMENTS(yfn0_a) GT 1 THEN PLOTS,xfn,yfn0_a,COLOR=!P.COLOR,NOCLIP=0,$
 			THICK = 1,PSYM=-5,SYMSIZE=0.5

	IF N_ELEMENTS(yfn0_b) GT 1 THEN PLOTS,xfn_b,yfn0_b,COLOR=1,NOCLIP=0,THICK=1,PSYM=4,SYMSIZE=0.6

;************************************************************************************

; Placing color bar
	junk = CONVERT_COORD(!X.CRANGE,!Y.CRANGE,/DATA,/TO_NORMAL)
	percent_bar = 1.0
	barchsize = 0.75*charsize/(1+(!P.MULTI(1) GT 2 OR !P.MULTI(2) GT 2))
	incx = 0.025*barchsize
	ysize = (junk(1,1)-junk(1,0))
	y0 = ysize/2+junk(1,0)
	x0 = junk(0,1)+incx
	labels = STRARR(nlev)
	lab_pos = [0,nlev/4,nlev/2,3*nlev/4,nlev-1]
	labels(lab_pos) = STRING(lev(lab_pos),FORMAT=makeformat)
	IF par EQ 0 THEN labels(lab_pos) = STRING(10^(lev(lab_pos)/10.),FORMAT=makeformat)
	MAKE_COLOR_BAR,x0,y0,incx,percent_bar*ysize/nlev,col=col,$
		label = labels,BORDER=-0,size=barchsize,TITLE=bartitle,$
		TOTAL_BORDER = 0, TOTAL_FILL = 0
	CONTROL_PLOT,pp=pp,CLOSE=1,FILENAME=figfilen,newpar=newpar,newpp=newpp, TABLEPATH=tablepath
	!P.MULTI = 0

END
