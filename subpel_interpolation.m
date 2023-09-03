%Written by Natalia Molinero Mingorance

function [subY_ref,subY] = subpel_interpolation(x,y,ref_Y,Y)
%for luma samples, we use the hfilter for 1/2 sample and the qfilter for
%1/4 sample precision
%%we use only luminance component for current and reference images

%ref_frame sub-pixel interpolation-->subY_ref

subY_ref=zeros(11,4);
subY=zeros(11,4);
i=1;
    
     for j=y-3:y+3 
         subY_ref(i,2)=-ref_Y(x-3,j)+4*ref_Y(x-2,j)-10*ref_Y(x-1,j)+58*ref_Y(x,j)-17*ref_Y(x+1,j)-5*ref_Y(x+2,j)+ref_Y(x+3,j); %axy    
         i=i+1;
     end

i=1;
        for j=y-3:y+3 
            subY_ref(i,3)=-ref_Y(x-3,j)+4*ref_Y(x-2,j)-11*ref_Y(x-1,j)+40*ref_Y(x,j)+40*ref_Y(x+1,j)-11*ref_Y(x+2,j)+4*ref_Y(x+3,j)+ref_Y(x+4,j); %bxy 
            i=i+1;

        end
    
i=1;
   
        for j=y-3:y+3 
            subY_ref(i,4)=ref_Y(x-2,j)-5*ref_Y(x-1,j)+17*ref_Y(x,j)+58*ref_Y(x+1,j)-10*ref_Y(x+2,j)+4*ref_Y(x+3,j)-ref_Y(x+4,j); %cxy 
           i=i+1;

        end
    
i=1;

        for j=y-3:y
                subY_ref(i,1)=ref_Y(x,j);%Axy
                i=i+1;

        end
     i=8;
        for j=y:y+3
                subY_ref(i,1)=ref_Y(x,j);%Axy
                i=i+1;

        end
    



subY_ref(5,2)=bitshift(int8(-subY_ref(1,2)+4*subY_ref(2,2)-10*subY_ref(3,2)+58*subY_ref(4,2)-17*subY_ref(8,2)-5*subY_ref(9,2)+subY_ref(10,2)),-6);
subY_ref(5,3)=bitshift(int8(-subY_ref(1,3)+4*subY_ref(2,3)-10*subY_ref(3,3)+58*subY_ref(4,3)-17*subY_ref(8,3)-5*subY_ref(9,3)+subY_ref(10,3)),-6);
subY_ref(5,4)=bitshift(int8(-subY_ref(1,4)+4*subY_ref(2,4)-10*subY_ref(3,4)+58*subY_ref(4,4)-17*subY_ref(8,4)-5*subY_ref(9,4)+subY_ref(10,4)),-6);

subY_ref(6,2)=bitshift(int8(-subY_ref(1,2)+4*subY_ref(2,2)-11*subY_ref(3,2)+40*subY_ref(4,2)+40*subY_ref(8,2)-11*subY_ref(9,2)+4*subY_ref(10,2)+subY_ref(11,2)),-6);
subY_ref(6,3)=bitshift(int8(-subY_ref(1,3)+4*subY_ref(2,3)-11*subY_ref(3,3)+40*subY_ref(4,3)+40*subY_ref(8,3)-11*subY_ref(9,3)+4*subY_ref(10,3)+subY_ref(11,3)),-6);
subY_ref(6,4)=bitshift(int8(-subY_ref(1,4)+4*subY_ref(2,4)-11*subY_ref(3,4)+40*subY_ref(4,4)+40*subY_ref(8,4)-11*subY_ref(9,4)+4*subY_ref(10,4)+subY_ref(11,4)),-6);

subY_ref(7,2)=bitshift(int8(subY_ref(1,2)-5*subY_ref(2,2)+17*subY_ref(3,2)+58*subY_ref(4,2)-10*subY_ref(8,2)+4*subY_ref(9,2)-subY_ref(10,2)),-6);
subY_ref(7,3)=bitshift(int8(subY_ref(1,3)-5*subY_ref(2,3)+17*subY_ref(3,3)+58*subY_ref(4,3)-10*subY_ref(8,3)+4*subY_ref(9,3)-subY_ref(10,3)),-6);
subY_ref(7,4)=bitshift(int8(subY_ref(1,4)-5*subY_ref(2,4)+17*subY_ref(3,4)+58*subY_ref(4,4)-10*subY_ref(8,4)+4*subY_ref(9,4)-subY_ref(10,4)),-6);


%target_frame sub-pixel interpolation-->subY

i=1;
    
     for j=y-3:y+3 
         subY(i,2)=-Y(x-3,j)+4*Y(x-2,j)-10*Y(x-1,j)+58*Y(x,j)-17*Y(x+1,j)-5*Y(x+2,j)+Y(x+3,j); %axy    
         i=i+1;
     end

i=1;
        for j=y-3:y+3 
            subY(i,3)=-Y(x-3,j)+4*Y(x-2,j)-11*Y(x-1,j)+40*Y(x,j)+40*Y(x+1,j)-11*Y(x+2,j)+4*Y(x+3,j)+Y(x+4,j); %bxy 
            i=i+1;

        end
    
i=1;
   
        for j=y-3:y+3 
            subY(i,4)=Y(x-2,j)-5*Y(x-1,j)+17*Y(x,j)+58*Y(x+1,j)-10*Y(x+2,j)+4*Y(x+3,j)-Y(x+4,j); %cxy 
           i=i+1;

        end
    
i=1;

        for j=y-3:y
                subY(i,1)=Y(x,j);%Axy
                i=i+1;

        end
     i=8;
        for j=y:y+3
                subY(i,1)=Y(x,j);%Axy
                i=i+1;

        end
    



subY(5,2)=bitshift(int8(-subY(1,2)+4*subY(2,2)-10*subY(3,2)+58*subY(4,2)-17*subY(8,2)-5*subY(9,2)+subY(10,2)),-6);
subY(5,3)=bitshift(int8(-subY(1,3)+4*subY(2,3)-10*subY(3,3)+58*subY(4,3)-17*subY(8,3)-5*subY(9,3)+subY(10,3)),-6);
subY(5,4)=bitshift(int8(-subY(1,4)+4*subY(2,4)-10*subY(3,4)+58*subY(4,4)-17*subY(8,4)-5*subY(9,4)+subY(10,4)),-6);

subY(6,2)=bitshift(int8(-subY(1,2)+4*subY(2,2)-11*subY(3,2)+40*subY(4,2)+40*subY(8,2)-11*subY(9,2)+4*subY(10,2)+subY(11,2)),-6);
subY(6,3)=bitshift(int8(-subY(1,3)+4*subY(2,3)-11*subY(3,3)+40*subY(4,3)+40*subY(8,3)-11*subY(9,3)+4*subY(10,3)+subY(11,3)),-6);
subY(6,4)=bitshift(int8(-subY(1,4)+4*subY(2,4)-11*subY(3,4)+40*subY(4,4)+40*subY(8,4)-11*subY(9,4)+4*subY(10,4)+subY(11,4)),-6);

subY(7,2)=bitshift(int8(subY(1,2)-5*subY(2,2)+17*subY(3,2)+58*subY(4,2)-10*subY(8,2)+4*subY(9,2)-subY(10,2)),-6);
subY(7,3)=bitshift(int8(subY(1,3)-5*subY(2,3)+17*subY(3,3)+58*subY(4,3)-10*subY(8,3)+4*subY(9,3)-subY(10,3)),-6);
subY(7,4)=bitshift(int8(subY(1,4)-5*subY(2,4)+17*subY(3,4)+58*subY(4,4)-10*subY(8,4)+4*subY(9,4)-subY(10,4)),-6);
