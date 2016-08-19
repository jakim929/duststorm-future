;landcover data by opening the netcdf file (wrfinput_d01)
;make copy the file 

temp2 = intarr(5,5)

fid = ncdf_open('DIR/wrfinput_d01.nc', /write)
  data = ncdf_varid(fid, 'IVGTYP')
  ncdf_varget, fid, data, IVGTYP
  
  ;loop...
  for i=0,110 do begin
     for j=0,116 do begin
        ;case 1
        if IVGTYP(i,j) eq 8 then temp(i,j) = 19
        ;case 2
        ;case 3
        if IVGTYP(i,j) eq 19 then begin
            temp(i-2:i+2,j-2:j+2) = 19
        endif
      endfor
    endfor
 index = where(IVGTYP eq 16, count)
 if count ne 0 then temp(index) = 16
 
ncdf_varput, fid, data, temp
ncdf_close, fid
end   
    
      