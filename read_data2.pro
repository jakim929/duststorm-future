pro read_data2,n, H, filename
openr, n, filename
H = intarr(117,111)
readf,n,H
print,stddev(H)
close,n
end