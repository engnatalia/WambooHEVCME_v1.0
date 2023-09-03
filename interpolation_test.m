% Written by Natalia Molinero Mingorance

%for luma MV 1/4 luma samples
%if using 4:2:0, for chroma, 1/8 samples

%for luma samples, we use the hfilter for 1/2 sample and the qfilter for
%1/4 sample precision:
indexes=[-3,-2,-1,0,1,2,3,4];
hfilter=[-1,4,-11,40,40,-11,4,1];
qfilter=[-1,4,-10,58,17,-5,1,];

%for chroma samples four different four-tapped FIR filters:
indexes=[-1,0,1,2];
filter1=[-2,58,10,-2]; %for chroma samples of 1/8th
filter2=[-4,54,16,-2];%for chroma samples of 2/8th
filter3=[-6,46,28,-4];%for chroma samples of 3/8th
filter4=[-4,36,36,-4];%for chroma samples of 4/8th

% 5/8th, 6/8th and 7/8th use filter3[1−i], filter2[1−i], and filter1[1−i]c

ref_frame = double(imread('1.jpg'));
target_frame = double(imread('2.jpg'));
ref_frame = ref_frame(1:256, 1:256, :); %%MIRAR CÓMO SE HACE CON EL TAMAÑALO REAL
target_frame = target_frame(1:256, 1:256, :); %%MIRAR CÓMO SE HACE CON EL TAMAÑALO REAL


%%we use only luminance component for current and reference images

R = ref_frame(:,:,1); G = ref_frame(:,:,2); B = ref_frame(:,:,3);
ref_Y=0.288*R+0.587*G+0.114*B;
R = target_frame(:,:,1); G = target_frame(:,:,2); B = target_frame(:,:,3);
Y=0.288*R+0.587*G+0.114*B;

dx=16;
dy=16;
subY_ref=zeros(11,4);
subY=zeros(11,4);

%ref_frame sub-pixel interpolation-->subY_ref


i=1;
    
     for j=dy-3:dy+3 
         subY_ref(i,2)=-ref_Y(dx-3,j)+4*ref_Y(dx-2,j)-10*ref_Y(dx-1,j)+58*ref_Y(dx,j)-17*ref_Y(dx+1,j)-5*ref_Y(dx+2,j)+ref_Y(dx+3,j); %adxdy    
         i=i+1;
     end

i=1;
        for j=dy-3:dy+3 
            subY_ref(i,3)=-ref_Y(dx-3,j)+4*ref_Y(dx-2,j)-11*ref_Y(dx-1,j)+40*ref_Y(dx,j)+40*ref_Y(dx+1,j)-11*ref_Y(dx+2,j)+4*ref_Y(dx+3,j)+ref_Y(dx+4,j); %bdxdy 
            i=i+1;

        end
    
i=1;
   
        for j=dy-3:dy+3 
            subY_ref(i,4)=ref_Y(dx-2,j)-5*ref_Y(dx-1,j)+17*ref_Y(dx,j)+58*ref_Y(dx+1,j)-10*ref_Y(dx+2,j)+4*ref_Y(dx+3,j)-ref_Y(dx+4,j); %cdxdy 
           i=i+1;

        end
    
i=1;

        for j=dy-3:dy
                subY_ref(i,1)=ref_Y(dx,j);%Adxdy
                i=i+1;

        end
     i=8;
        for j=dy:dy+3
                subY_ref(i,1)=ref_Y(dx,j);%Adxdy
                i=i+1;

        end
    



subY_ref(5,2)=bitshift(-subY_ref(1,2)+4*subY_ref(2,2)-10*subY_ref(3,2)+58*subY_ref(4,2)-17*subY_ref(8,2)-5*subY_ref(9,2)+subY_ref(10,2),6);
subY_ref(5,3)=bitshift(-subY_ref(1,3)+4*subY_ref(2,3)-10*subY_ref(3,3)+58*subY_ref(4,3)-17*subY_ref(8,3)-5*subY_ref(9,3)+subY_ref(10,3),6);
subY_ref(5,4)=bitshift(-subY_ref(1,4)+4*subY_ref(2,4)-10*subY_ref(3,4)+58*subY_ref(4,4)-17*subY_ref(8,4)-5*subY_ref(9,4)+subY_ref(10,4),6);

subY_ref(6,2)=bitshift(-subY_ref(1,2)+4*subY_ref(2,2)-11*subY_ref(3,2)+40*subY_ref(4,2)+40*subY_ref(8,2)-11*subY_ref(9,2)+4*subY_ref(10,2)+subY_ref(11,2),6);
subY_ref(6,3)=bitshift(-subY_ref(1,3)+4*subY_ref(2,3)-11*subY_ref(3,3)+40*subY_ref(4,3)+40*subY_ref(8,3)-11*subY_ref(9,3)+4*subY_ref(10,3)+subY_ref(11,3),6);
subY_ref(6,4)=bitshift(-subY_ref(1,4)+4*subY_ref(2,4)-11*subY_ref(3,4)+40*subY_ref(4,4)+40*subY_ref(8,4)-11*subY_ref(9,4)+4*subY_ref(10,4)+subY_ref(11,4),6);

subY_ref(7,2)=bitshift(subY_ref(1,2)-5*subY_ref(2,2)+17*subY_ref(3,2)+58*subY_ref(4,2)-10*subY_ref(8,2)+4*subY_ref(9,2)-subY_ref(10,2),6);
subY_ref(7,3)=bitshift(subY_ref(1,3)-5*subY_ref(2,3)+17*subY_ref(3,3)+58*subY_ref(4,3)-10*subY_ref(8,3)+4*subY_ref(9,3)-subY_ref(10,3),6);
subY_ref(7,4)=bitshift(subY_ref(1,4)-5*subY_ref(2,4)+17*subY_ref(3,4)+58*subY_ref(4,4)-10*subY_ref(8,4)+4*subY_ref(9,4)-subY_ref(10,4),6);


%target_frame sub-pixel interpolation-->subY

i=1;
    
     for j=dy-3:dy+3 
         subY(i,2)=-ref_Y(dx-3,j)+4*ref_Y(dx-2,j)-10*ref_Y(dx-1,j)+58*ref_Y(dx,j)-17*ref_Y(dx+1,j)-5*ref_Y(dx+2,j)+ref_Y(dx+3,j); %adxdy    
         i=i+1;
     end

i=1;
        for j=dy-3:dy+3 
            subY(i,3)=-ref_Y(dx-3,j)+4*ref_Y(dx-2,j)-11*ref_Y(dx-1,j)+40*ref_Y(dx,j)+40*ref_Y(dx+1,j)-11*ref_Y(dx+2,j)+4*ref_Y(dx+3,j)+ref_Y(dx+4,j); %bdxdy 
            i=i+1;

        end
    
i=1;
   
        for j=dy-3:dy+3 
            subY(i,4)=ref_Y(dx-2,j)-5*ref_Y(dx-1,j)+17*ref_Y(dx,j)+58*ref_Y(dx+1,j)-10*ref_Y(dx+2,j)+4*ref_Y(dx+3,j)-ref_Y(dx+4,j); %cdxdy 
           i=i+1;

        end
    
i=1;

        for j=dy-3:dy
                subY(i,1)=ref_Y(dx,j);%Adxdy
                i=i+1;

        end
     i=8;
        for j=dy:dy+3
                subY(i,1)=ref_Y(dx,j);%Adxdy
                i=i+1;

        end
    



subY(5,2)=bitshift(-subY(1,2)+4*subY(2,2)-10*subY(3,2)+58*subY(4,2)-17*subY(8,2)-5*subY(9,2)+subY(10,2),6);
subY(5,3)=bitshift(-subY(1,3)+4*subY(2,3)-10*subY(3,3)+58*subY(4,3)-17*subY(8,3)-5*subY(9,3)+subY(10,3),6);
subY(5,4)=bitshift(-subY(1,4)+4*subY(2,4)-10*subY(3,4)+58*subY(4,4)-17*subY(8,4)-5*subY(9,4)+subY(10,4),6);

subY(6,2)=bitshift(-subY(1,2)+4*subY(2,2)-11*subY(3,2)+40*subY(4,2)+40*subY(8,2)-11*subY(9,2)+4*subY(10,2)+subY(11,2),6);
subY(6,3)=bitshift(-subY(1,3)+4*subY(2,3)-11*subY(3,3)+40*subY(4,3)+40*subY(8,3)-11*subY(9,3)+4*subY(10,3)+subY(11,3),6);
subY(6,4)=bitshift(-subY(1,4)+4*subY(2,4)-11*subY(3,4)+40*subY(4,4)+40*subY(8,4)-11*subY(9,4)+4*subY(10,4)+subY(11,4),6);

subY(7,2)=bitshift(subY(1,2)-5*subY(2,2)+17*subY(3,2)+58*subY(4,2)-10*subY(8,2)+4*subY(9,2)-subY(10,2),6);
subY(7,3)=bitshift(subY(1,3)-5*subY(2,3)+17*subY(3,3)+58*subY(4,3)-10*subY(8,3)+4*subY(9,3)-subY(10,3),6);
subY(7,4)=bitshift(subY(1,4)-5*subY(2,4)+17*subY(3,4)+58*subY(4,4)-10*subY(8,4)+4*subY(9,4)-subY(10,4),6);

costs= costFuncSATD(subY_ref,subY);