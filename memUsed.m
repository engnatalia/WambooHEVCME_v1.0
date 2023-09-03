%memory used by Matlab in MB

function y = memUsed
usr = memory;
y = usr.MemUsedMATLAB/1e6;