pro read_data1,n, H, filename
openr, n, filename
H = fltarr(365)
readf,n,H
print,stddev(H)
close,n
end