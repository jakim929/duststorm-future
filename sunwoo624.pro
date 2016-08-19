nday = [31,28,31,30,31,30,31,31,30,31,30,31]
SSI_mon = fltarr(117,111,12)
vdf_avg = fltarr(117,111,12)
hdf_avg = fltarr(117,111,12)
windv_avg = fltarr(117,111,12)
smois_avg = fltarr(117,111,12)
ust_avg = fltarr(117,111,12)
tust_avg = fltarr(117,111,12)

for m = 1, 12 do begin
    month = strcompress(string(m), /remove_all)
    if m lt 10 then month = '0'+month
    SSI = fltarr(117,111)
    vdf_ms = fltarr(117,111)
    hdf_ms = fltarr(117,111)
    windv_max = fltarr(117,111)
    smois_max = fltarr(117,111)
    ust_ms = fltarr(117,111)
    tust_ms = fltarr(117,111)
    for d = 1, nday(m-1) do begin
        SSI_temp = intarr(117,111)
        date = strcompress(string(d), /remove_all)
        if d lt 10 then date = '0'+date
        HI_temp = intarr(120,100)
        SCS = [[90,5,5],[80,5,15],[65,10,25],[20,15,65],[5,5,90],[40,20,40],[60,25,15],[10,35,55],$
        [30,35,35],[50,45,5],[5,50,45],[15,70,15],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]
        vdf_max = fltarr(117,111)
        hdf_max = fltarr(117,111)
        ust_max = fltarr(117,111)
        tust_max = fltarr(117,111)
        
        for tt = 0, 3 do begin
            ttt = tt*6
            time = strcompress(string(ttt), /remove_all)
            if ttt lt 10 then time = '0'+time
            ;fname = '/home2/sunwoo/WRFV3/'+ $
            fname =  '/home2/sunwoo/noahmp_coupled_wrfv3.3.1_r1052_20120127/' + $
                    'run/wrfout_d01_2081-'+month+'-'+date+'_'+time+':00:00'
            fid = ncdf_open(fname, /nowrite)
            data = ncdf_varid(fid, 'UST')
            ncdf_varget, fid, data, UST
            data = ncdf_varid(fid, 'U10')
            ncdf_varget, fid, data, U10
            data = ncdf_varid(fid, 'V10')
            ncdf_varget, fid, data, V10
            data = ncdf_varid(fid, 'ISLTYP')
            ncdf_varget, fid, data, ISLTYP
            data = ncdf_varid(fid, 'LANDMASK')
            ncdf_varget, fid, data, LANDMASK
            data = ncdf_varid(fid, 'PSFC')
            ncdf_varget, fid, data, PSFC
            data = ncdf_varid(fid, 'T2')
            ncdf_varget, fid, data, T2
            data = ncdf_varid(fid, 'Q2')
            ncdf_varget, fid, data, Q2            
            data = ncdf_varid(fid, 'SMOIS')
            ncdf_varget, fid, data, SMOIS
            data = ncdf_varid(fid, 'MU')
            ncdf_varget, fid, data, MU
            data = ncdf_varid(fid, 'MUB')
            ncdf_varget, fid, data, MUB
            ncdf_close, fid
            
            
                for dx = 0, 116 do begin
                    for dy = 0, 110 do begin
                      t_smois  = float(SMOIS(dx,dy,0))
                    	stype = ISLTYP(dx, dy)
                    	t_u10 = U10(dx,dy)
                    	t_v10 = V10(dx,dy)
                    	t_ust = UST(dx,dy)
                    	t_lm = LANDMASK(dx,dy)
                    	t_psfc = PSFC(dx,dy)
                    	t_t2 = T2(dx,dy)
                    	t_q2 = Q2(dx,dy)
                    	t_mu = MU(dx,dy)
                    	t_mub = MUB(dx,dy)
                    	
                    	pq0 = 379.90516
                      a2 = 17.2693882
                      a3 = 273.16
                      a4 = 35.86
                      t_rh = t_q2 / ( (pq0 / t_psfc) * exp(a2 * (t_t2 - a3) / (t_t2 - a4)) ) ;relative humidity
                      if t_rh gt 1. then t_rh = 1.
                          
                      
                    	t_sand = float(SCS[0,stype-1])
                    	t_clay = float(SCS[1,stype-1])
                    	t_silt = float(SCS[2,stype-1])
                    	t_efp = 29.09 + 0.31*t_sand + 0.17*t_silt + 0.33*t_clay - 0.475
                    	t_ef = t_efp / 100.
                    	;if (stype eq 1 or stype eq 2) then begin 
                    	;t_pp = 5000 
                    	;endif else if (stype ge 3 and stype le 9) then begin
                    	;t_pp = 10000 
                    	;endif else if (stype ge 10 and stype le 12) then begin
                    	;t_pp = 30000 
                    	;endif else then begin
                    	;t_pp = 100000000
                    	;endelse
                    	t_wpara = (t_u10^2 + t_v10^2)^(0.5)
                    	t_vdf = float(t_ef * (2.9*10.^(-4)) * t_ust)
                    	;t_ad = t_psfc/(287.05*t_t2)
                    	t_gsavg = 1.037 * (t_sand/100.) + 0.0018* (t_clay/100.) + 0.0395* (t_silt/100.)
                    	t_fmu = t_mu + t_mub           ;air column (dry) mass
                    	t_vpsat = (6.1078 * 10^((7.5*t_t2)/(t_t2 +237.3)))/100  
                    	t_vp = t_vpsat * t_rh 
                    	t_ad = (t_fmu / (287.058 * t_t2)) + (t_vp / (461.495 * t_t2))
                      
                    	;t_hdf = 1.8* (t_gsavg/0.25)^1/2 *t_ad*t_ust^3
                    	
                    	t_tsmois = float(0.0014 * (float(t_clay))^2 + 0.17 * (float(t_clay)))
                    	if t_smois gt t_tsmois then begin
                    	      ;t_mcf = (1+ 1.21*(t_smois - t_tsmois)^0.68)^0.5
                    	endif else begin
                    	      t_mcf = float(1)
                    	endelse
                    	t_rcf = 1 ;temporary
                    	t_pd = 2.567* (t_sand/100.) + 2.798* (t_silt/100.) + 2.837* (t_clay/100.)
                    	t_tust = ((0.0123 * ((t_pd/t_ad)*9.8*t_gsavg + (3*10^(-4))/(t_ad* t_gsavg)))^0.5) * t_rcf * t_mcf
                    	if t_ust gt t_tust then begin
                    	   ;t_hdf = 1.8* (t_gsavg/0.25)^1/2 *t_ad*t_ust^3
                         t_hdf = 2.1 * (t_ad/ 9.8) * (t_ust^3.) * (1.- (t_tust/t_ust)) * (1. + (t_tust/t_ust)^2)
                    	endif else begin
                    	      t_hdf = 0;
                    	endelse
                    	
                    	windv_max(dx,dy) = windv_max(dx,dy) + t_wpara
                    	smois_max(dx,dy) = smois_max(dx,dy) + t_smois
                      tust_max(dx,dy) = tust_max(dx,dy) + t_tust
                      ust_max(dx,dy) = ust_max(dx,dy) + t_ust
                    	if t_lm eq 1 and t_ust gt t_tust and t_wpara ge 8. and t_vdf ge 40.07*10.^(-3) and t_hdf ge 2.56*10.^(1) then begin
                    	
                             SSI_temp(dx,dy) = SSI_temp(dx,dy) + 1
                            ;print, t_vdf, t_hdf        
                            if t_vdf gt vdf_max(dx,dy) then vdf_max(dx,dy) = t_vdf
                            if t_hdf gt hdf_max(dx,dy) then hdf_max(dx,dy) = t_hdf

                        endif
                        
                    endfor ; end of dy
                endfor ; end of dx
                ;print, max(vdf_max), max(hdf_max)c
        
        endfor ; end of hour loop
        index = where(SSI_temp ge 1., count)
        if count ne 0 then SSI(index) = SSI(index) + 1
        hdf_ms = hdf_ms+hdf_max
        vdf_ms = vdf_ms+vdf_max

        print, month+' '+date
    endfor ; end of day loop
    SSI_mon(*,*,m-1) = SSI(*,*)
    smois_avg(*,*,m-1) = smois_max(*,*)/nday(m-1)/4
    windv_avg(*,*,m-1) = windv_max(*,*)/nday(m-1)/4
    tust_avg(*,*,m-1) = tust_max(*,*)/nday(m-1)/4
    ust_avg(*,*,m-1) = ust_max(*,*)/nday(m-1)/4
    index = where(SSI ne 0, count)
    print, max(hdf_ms), max(vdf_ms)
    if count ne 0 then begin
       vdf_ms(index) = vdf_ms(index)/SSI(index)
       hdf_ms(index) = hdf_ms(index)/SSI(index)
    endif
    vdf_avg(*,*,m-1) = vdf_ms(*,*)
    hdf_avg(*,*,m-1) = hdf_ms(*,*)
;    stop
endfor ; end of month loop

;write_tiff, '/home2/sunwoo/mask.tif', t_lm, /long
write_tiff, '/home2/sunwoo/SSI_output_current.tif', SSI_mon, /long
write_tiff, '/home2/sunwoo/hdf_output_current.tif', hdf_avg, /float
write_tiff, '/home2/sunwoo/vdf_output_current.tif', vdf_avg, /float
write_tiff, '/home2/sunwoo/wind_output_current.tif', windv_avg, /float
write_tiff, '/home2/sunwoo/smois_output_current.tif', smois_avg, /float
write_tiff, '/home2/sunwoo/ust_output_current.tif', ust_avg, /float
write_tiff, '/home2/sunwoo/tust_output_current.tif', tust_avg, /float

end