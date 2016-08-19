nday = [31,28,31,30,31,30,31,31,30,31,30,31]
SSI_mon = fltarr(117,111,12)
vdf_avg = fltarr(117,111,12)
hdf_avg = fltarr(117,111,12)
windv_avg = fltarr(117,111,12)
smois_avg = fltarr(117,111,12)
ust_avg = fltarr(117,111,12)
tust_avg = fltarr(117,111,12)
checker = 0.0

dayCount = 1

ust_daily = fltarr(117,111,365)

point_vdf = fltarr(365)
point_ust = fltarr(365)
point_tust = fltarr(365)
dxstart = 45
dxend = 50
dystart = 85
dyend = 90
dxcount = dxend - dxstart +1
dycount = dyend - dystart +1
limitCount = dxcount * dycount
startDay = 1

for m = 1, 12 do begin
    month = strcompress(string(m), /remove_all)
    if m lt 10 then month = '0'+month
    SSI = fltarr(117,111)
    overCount = fltarr(117,111)
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
        SCS = [[90,5,5,21.19,0.68,0.005],[80,5,15,30,0.90,0.01],[65,10,25,44.87,0.85,0.037],$
        [20,15,65,21.79,0.67,0.059],[5,5,90,20.73,0.088,0.64],[40,20,40,17.79,0.61,0.049],$
        [60,25,15,25.79,0.74,0.075],[10,35,55,27.50,0.75,0.110],[30,35,35,29.86,0.80,0.095],$
        [50,45,5,25.20,0.70,0.125],[5,50,45,22.90,0.65,0.140],[15,70,15,20.47,0.54,0.171],$
        [0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]
        vdf_max = fltarr(117,111)
        hdf_max = fltarr(117,111)
        ust_max = fltarr(117,111)
        tust_max = fltarr(117,111)
        
        ust_temp = fltarr(117,111)
        
        for tt = 0, 3 do begin
            ttt = tt*6
            time = strcompress(string(ttt), /remove_all)
            if ttt lt 10 then time = '0'+time
            fname = '/home2/sunwoo/WRFV3/'+ $
            ;fname =  '/home2/sunwoo/noahmp_coupled_wrfv3.3.1_r1052_20120127/' + $
                    'run/wrfout_d01_2001-'+month+'-'+date+'_'+time+':00:00'
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
                          
                      
                    	t_sand = float(SCS[0,stype-1])  ; sand fraction
                    	t_clay = float(SCS[1,stype-1])	; clay fraction
                    	t_silt = float(SCS[2,stype-1])	; silt fraction
                    	t_coea = float(SCS[3,stype-1])	; coefficient a for moisture correction
                    	t_coeb = float(SCS[4,stype-1])	; coefficient b for moisture correction
                    	t_coew = float(SCS[5,stype-1])	; coefficient wt for moisture correction
                    	
                    	t_efp = 29.09 + 0.31*t_sand + 0.17*t_silt + 0.33*t_clay - 0.475 ; erodible fraction percentage
                    	t_ef = t_efp / 100.  ; erodible fraction
                    	;if (stype eq 1 or stype eq 2) then begin 
                    	;t_pp = 5000 
                    	;endif else if (stype ge 3 and stype le 9) then begin
                    	;t_pp = 10000 
                    	;endif else if (stype ge 10 and stype le 12) then begin
                    	;t_pp = 30000 
                    	;endif else then begin
                    	;t_pp = 100000000
                    	;endelse
                    	
                    	
                    	t_wpara = (t_u10^2 + t_v10^2)^(0.5) ; wind speed
                    	;t_vdf = float(t_ef * (2.9*10.^(-4)) * t_ust) ;vertical dust flux
                    	;t_ad = t_psfc/(287.05*t_t2)
                    	;t_gsavg = (125.0) * (float(t_sand)/100.) + (3.0)* (float(t_clay)/100.) + (33.2) *(float(t_silt)/100.) ; grain size average in meters - correct later for sand
                    	;t_gsavg = (0.1250) * (float(t_sand)/100.) + (0.0030)* (float(t_clay)/100.) + (0.0332) *(float(t_silt)/100.) ; grain size average in meters - correct later for sand
                    	t_gsavg = (0.000125) * (float(t_sand)/100.) + (0.000003)* (float(t_clay)/100.) + (0.0000332) *(Float(t_silt)/100.) ; grain size average in meters - correct later for sand
                    	;t_gsavg = 0.0001
                    	t_fmu = t_mu + t_mub           ;air column (dry) mass
                    	t_vpsat = (6.1078 * 10^((7.5*t_t2)/(t_t2 +237.3)))/100  
                    	t_vp = t_vpsat * t_rh 
                    	;t_ad = (t_fmu / (287.058 * t_t2)) + (t_vp / (461.495 * t_t2)) ;air density
                    	t_ad = (t_fmu * 0.028964 + t_vp * 0.018016)/(8.314 * t_t2)
                    	t_df = t_clay + t_silt
                    	checker = checker + t_gsavg
                    	;t_ca = 
                      	
                      	case t_gsavg of ; settling velocity chart from Shao 2001
                      		(t_gsavg gt 0) and (t_gsavg le 2*10^(-6)): t_wt = 1.8*10^(-4)
                      		(t_gsavg gt 2*10^(-6)) and (t_gsavg le 11*10^(-6)): t_wt = 2.86*10^(-3)
                      		(t_gsavg gt 11*10^(-6)) and (t_gsavg le 22*10^(-6)): t_wt = 1.876*10^(-2)
                      		(t_gsavg gt 22*10^(-6)) and (t_gsavg le 52*10^(-6)): t_wt = 9.896*10^(-2)
                      		(t_gsavg gt 52*10^(-6)) and (t_gsavg le 90*10^(-6)): t_wt = 0.4259
                      		(t_gsavg gt 90*10^(-6)) and (t_gsavg le 125*10^(-6)): t_wt = 0.8
                      		else: t_wt = 0.8
                      	endcase
                      	
                    	;t_hdf = 1.8* (t_gsavg/0.25)^1/2 *t_ad*t_ust^3
                    	
                    	t_tsmois = float(0.0014 * (float(t_clay))^2 + 0.17 * (float(t_clay))) ; threshold soil moisture
                    	
                    	if t_smois gt t_coew then begin
                    	      t_mcf = (1.0+ t_coea*(t_smois - t_coew)^t_coeb)^0.5   ; Soil moisture content correction factor
                    	endif else begin
                    	      t_mcf = float(1)
                    	endelse
                    	
                    	t_rcf = 1. ;temporary	;roughness correction factor
                    	
                    	t_pd =1000 *( 2.567* (t_sand/100.) + 2.798* (t_silt/100.) + 2.837* (t_clay/100.))	;particle density
                    	t_tust = ((0.0123 * ((t_pd/t_ad)*9.8*t_gsavg + (1.65*10^(-4))/(t_ad* t_gsavg)))^0.5) * t_rcf * t_mcf	
                    	;threshold u* can be 1.65 - 3
                    	
                    	
                    	t_oc = 0.25 + 0.33*float(t_wt/t_ust)
                    	
                    	if t_ust gt t_tust then begin
                    		;checker = checker + 1
                    		;t_hdf = 1.8* (t_gsavg/0.25)^1/2 *t_ad*t_ust^3
                        	;t_hdf = 2.1 * (t_ad/ 9.8) * (t_ust^3.) * (1.- (t_tust/t_ust)) * (1. + (t_tust/t_ust)^2)
                        	;t_hdf = ((t_oc * t_ad * (t_ust^3))/9.8)*(1-(t_tust/t_ust)^2) ; Owen 1964 for uniform particle
                        	t_hdf = 0.0004 * t_ad * t_ust * (t_ust - t_tust) * (t_ust + 7.6 * t_tust+ 205.0)  ;Sorensen 2001
                    	endif else begin
                    	      t_hdf = 0.0;
                    	endelse
                    	
                    	
                    	t_a = float(0.0)
                    	case t_clay of ; Marticorena Bergametti 1995, Tegen et al 2001 - Astitha 2012 under 20micrometers
                    		(t_clay ge 0) and (t_clay lt 20): t_a = (10.^ ((0.134 * t_clay)-6)) * 10.^(2) 
                    		(t_clay ge 20) and (t_clay lt 45): t_a = (10.^ (-6)) * 10.^(2)
                    		else: t_a = 10.^(-5)
                    	endcase
                    	
                    	;t_vdf = float(t_ef * (2.9*10.^(-4)) * t_ust) ;vertical dust flux
                    	t_vdf = t_a * t_hdf
                    	
                    	
                    	if t_ust gt ust_temp(dx,dy) then begin
                    		ust_temp(dx,dy) = t_ust
                    	endif
                    	
                    	windv_max(dx,dy) = windv_max(dx,dy) + t_wpara
                    	;smois_max(dx,dy) = smois_max(dx,dy) + t_smois
                      	;tust_max(dx,dy) = tust_max(dx,dy) + t_tust
                      	;ust_max(dx,dy) = ust_max(dx,dy) + t_ust
                      	

                      	
                    	if t_lm eq 1 and t_ust gt t_tust then begin ;and t_wpara ge 8. and t_vdf ge 40.07*10.^(-7) and t_hdf ge 258.67*10.^(-4) then begin
                    	;if t_lm eq 1 and t_wpara ge 8. and t_vdf ge 40.07*10.^(-7) and t_hdf ge 255.67*10.^(-4)and t_ust gt t_tust then begin
                    	
                             SSI_temp(dx,dy) = SSI_temp(dx,dy) + 1
                            ;print, t_vdf, t_hdf        
                            
                        	
                            if t_vdf gt vdf_max(dx,dy) then vdf_max(dx,dy) = t_vdf
                            if t_hdf gt hdf_max(dx,dy) then hdf_max(dx,dy) = t_hdf
                            if t_ust gt ust_max(dx,dy) then ust_max(dx,dy) = t_ust
							if t_tust gt tust_max(dx,dy) then tust_max(dx,dy) = t_tust

							
						
                        endif
                        
                    endfor ; end of dy
                endfor ; end of dx
                
                ;print, max(vdf_max), max(hdf_max)
        endfor ; end of hour loop
        index = where(SSI_temp ge 1., count)
        if count ne 0 then SSI(index) = SSI(index) + 1
        hdf_ms = hdf_ms+hdf_max
        vdf_ms = vdf_ms+vdf_max
		
		ust_daily(*,*,dayCount-1) = ust_temp(*,*)
		dayCount = dayCount + 1
		
		
		dayUst = float(0)
		dayVDF = float(0)
		dayTust = float(0)
		realCountUst = 0
		realCountVdf = 0
		realCountTust = 0
		
		for xst = dxstart, dxend do begin
			for yst = dystart, dyend do begin
			
				if vdf_max(xst,yst) ne 0.0 then begin
					dayVdf = dayVdf + vdf_max(xst,yst)
					realCountVdf = realCountVdf + 1
				endif 
				
				if ust_max(xst,yst) ne 0.0 then begin
					dayUst = dayUst + ust_max(xst,yst)
					realCountUst = realCountUst + 1
				endif
				
				
				if tust_max(xst,yst) ne 0.0 then begin
					dayTust = dayTust + tust_max(xst,yst)
					realCountTust = realCountTust + 1
				endif  
				
				
			endfor
			
		endfor
		if (realCountVdf ne 0) then begin
		  vdfDailyAvg = dayVdf / realCountVdf
		endif else begin  
			vdfDailyAvg = 0
		endelse
		
		if (realCountUst ne 0) then begin
		  ustDailyAvg = dayUst / realCountUst
		endif else begin  
			ustDailyAvg = 0
		endelse
		
		if (realCountTust ne 0) then begin
		  tustDailyAvg = dayTust / realCountTust
		endif else begin  
			ustDailyAvg = 0
		endelse
		
		
		point_vdf(startDay-1) = vdfDailyAvg
		point_ust(startDay-1) = ustDailyAvg
		point_tust(startDay-1) = tustDailyAvg
		startDay = startDay + 1

        print, month+' '+date
        print, max(vdf_max), max(hdf_max)
    endfor ; end of day loop
    SSI_mon(*,*,m-1) = SSI(*,*)
    smois_avg(*,*,m-1) = smois_max(*,*)/nday(m-1)/4
    windv_avg(*,*,m-1) = windv_max(*,*)/nday(m-1)/4
    tust_avg(*,*,m-1) = tust_max(*,*)/nday(m-1)/4
    ;ust_avg(*,*,m-1) = ust_max(*,*)/nday(m-1)/4
    index = where(SSI ne 0, count)
    ;print, max(hdf_ms), max(vdf_ms)
    if count ne 0 then begin
       vdf_ms(index) = vdf_ms(index)/SSI(index)
       hdf_ms(index) = hdf_ms(index)/SSI(index)


    endif
    vdf_avg(*,*,m-1) = vdf_ms(*,*)
    hdf_avg(*,*,m-1) = hdf_ms(*,*)
;    stop
endfor ; end of month loop


;write_tiff, '/home2/sunwoo/mask.tif', t_lm, /long
;write_tiff, '/home2/sunwoo/SSI_output_current.tif', SSI_mon, /long
;write_tiff, '/home2/sunwoo/hdf_output_current.tif', hdf_avg, /float
;write_tiff, '/home2/sunwoo/vdf_output_current.tif', vdf_avg, /float
;write_tiff, '/home2/sunwoo/wind_output_current.tif', windv_avg, /float
;write_tiff, '/home2/sunwoo/smois_output_current.tif', smois_avg, /float
;write_tiff, '/home2/sunwoo/ust_output_current.tif', ust_avg, /float
;write_tiff, '/home2/sunwoo/tust_output_current.tif', tust_avg, /float
;write_tiff, '/home2/sunwoo/ust_dailyoutput_current.tif', ust_daily, /float
;write_tiff, '/home2/sunwoo/output/point_vdf_dxdy_current', point_vdf, /float

end