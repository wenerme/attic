declare function ScreenPrint_Rect( ScrP_p_PAGE, ScrP_p_x, ScrP_p_y, ScrP_p_Wid, ScrP_p_Hgt, ScrP_p_BMP_FileName$)
const ScreenPrint_Use_File_ID = 1

declare function lib2bmp()
setlcd( 240, 320)
print "ʹ�÷�����"
print "    �Զ��� Lib2Bmp.lib�е�����ͼƬת��"
print "��bmp��"
print "    bmp������Ϊ"
print "       SP_Wen-{������}-{��ǰ�ڼ���}"
print
print "��ȷ�ϼ���ת��"
print "���˳��˳�����ת��"

jixuXunhuan:

wk = waitkey()



if wk = key_escape then


	cls
	locate( 1, 1)
vasm(" lable_Exit:")
	
	print
	print "�˳�����"
	
	print "ллʹ��"
	
	print "������Ϣ"	
	print "���� Wener"
	print "ID a3160586"
	print "      club.eebbk.com"
	
	print "qq 514403150"
	
	msdelay( 1500)
	end
else if wk = key_enter then

cls
locate( 1, 1)
print "��ʼת��"

lib2bmp()

vasm(" jmp lable_Exit")

print "ת�����"

else

goto jixuXunhuan:

end if


'//��������
function lib2bmp()
dim shared fn$, count, cur, im, page, wid, hgt, bfn$

fn$ = "Lib2Bmp.lib"

open fn$ for binary as #1

if lof( 1) < 8 then

print "Lib�ļ������޷�ת��"

vasm(" jmp lable_Exit")
end if


page = createpage()
get #1, count
close #1

print "����ͼƬ" + count + " ��"

print "ת����.";

cur = 1
while cur < = count

im = loadres( fn$, cur)
wid = getpicwid( im)
hgt = getpichgt( im)
fillpage( page, 0, 0, 240, 320, &hff00ff)
showpic( page, im, 0, 0, wid, hgt, 0, 0, 1)

ScreenPrint_Rect(page, 0, 0, wid, hgt,  "SP_WEN-" + count + "-" + cur )



print ".";
cur = cur + 1
wend

end function




























'//���ν�ͼ
function ScreenPrint_Rect( ScrP_p_PAGE, ScrP_p_x, ScrP_p_y, ScrP_p_Wid, ScrP_p_Hgt, ScrP_p_BMP_FileName$)
'//=========��ͼ�ຯ�� ֮�ֲ���ͼ==========
'���� Wener
'��̳Id a3160586 (club.eebbk.com   �����)
'QQ 514403150
Dim Shared ScrP_src_x, ScrP_src_y
Dim Shared ScrP_x, ScrP_y, ScrP_page
Dim Shared ScrP_wid, ScrP_hgt
Dim Shared ScrP_FileHandle, ScrP_FileName$, ScrP_FileOffset
Dim Shared Scrp_DataOffSet, Scrp_Save_PreLine
Dim Shared ScrP_BMP_FileName$

ScrP_page = ScrP_p_PAGE

ScrP_FileHandle = ScreenPrint_Use_File_ID
ScrP_BMP_FileName$ = ScrP_p_BMP_FileName$

ScrP_src_x = ScrP_p_x
ScrP_src_y = ScrP_p_y
ScrP_Wid = ScrP_p_Wid
ScrP_hgt = ScrP_p_Hgt

asm
;'����������
call ScreenCapture_CommonInitialization
call [ ScreenCapture_MainProcess_TYPE ]
endasm

end function



asm
Jmp Scrp_QingWuShi:
;���ݿ�
ScreenCapture_Catch:
.block 1 0
ScreenCapture_Catch_SavePostion:
.block 4096 0

;��ɫ
ScreenCapture_ColorTranslate_Catch_Blue:
.block 1 0
ScreenCapture_ColorTranslate_Catch_Green:
.block 1 0
ScreenCapture_ColorTranslate_Catch_Red:
.block 2 0

;16λɫ�Ļ���
ScreenCapture_ColorTranslate_Catch_16Bit_1:
.block 1 0
ScreenCapture_ColorTranslate_Catch_16Bit_2:
.block 3 0

;����һЩ�˿ڵĲ����б�
ScreenCapture_Paramater_4:
.block 4 0
ScreenCapture_Paramater_3:
.block 4 0
ScreenCapture_Paramater_2:
.block 4 0
ScreenCapture_Paramater_1:
.block 4 0
ScreenCapture_Paramater_Catch:

;��ʼ���Ļ���
ScreenCapture_Init_Bit1:
.block 2 0
ScreenCapture_Init_Bit2:
.block 4 0

data Scrp_i dword 0
data Scrp_j dword 0
data Scrp_k dword 0
data ScreenCapture_Color_Tranform_TYPE dword 0
data ScreenCapture_SaveAs_TYPE dword 0
data ScreenCapture_MainProcess_TYPE dword 0
;//=============��ɫת������=============//
;�ӹ��̣���BGR����ɫ��ʽ��RGB����ת��
;��������������Ƕ���ģ�Ӧ�ö������õ�~
ScreenCapture_ColorTranslate:
;������ r0 
;���أ� r0




ld int [ ScreenCapture_ColorTranslate_Catch_Blue ], r0
ld byte r0, [ ScreenCapture_ColorTranslate_Catch_Blue ]

ld byte [ ScreenCapture_ColorTranslate_Catch_Blue ], [ ScreenCapture_ColorTranslate_Catch_Red ]
ld byte [ ScreenCapture_ColorTranslate_Catch_Red ], r0

ld int r0, [ ScreenCapture_ColorTranslate_Catch_Blue ]
ret
;
;//==========�ӹ��̣���R8 G8 B8ת����R5 G6 B5==========//
;'������ƣ���ʼΪ-1
data ScreenCapture_ColorTranslate_LastColor_Catch dword %ffffffff%

ScreenCapture_ColorCover_16Bit:
;����: r0
;����: r0 ����ֵ��8λ����ɫ

;'if r0 = LastColor_Catch ����
;\\
cmp int r0, [ ScreenCapture_ColorTranslate_LastColor_Catch ]
jpc z ScreenCapture_ColorTranslate_ColorEqual:

ld int [ ScreenCapture_ColorTranslate_LastColor_Catch ], r0
;'������ε���ɫ��ͬ���򲻴���

;\\
ld int [ ScreenCapture_ColorTranslate_Catch_Blue ], r0

ld int r1, 0
ld int r2, 0
ld int r3, 0
;��ɫ ȡɫ

call [ ScreenCapture_Color_Tranform_TYPE ]


ld int r0, r1
cal int add r0, r2
cal int add r0, r3



;����00
ld int [ ScreenCapture_ColorTranslate_Catch_16Bit_1 ], r0



;������߼�����ȷ ��ɫƫ��û��ô�ѿ�
; if bit12 = 0 then
;	bit12 = 2113
; else
;	if bite1 = 0 then
;		bit2 + 1
;		
;	else
;		bit2 + 8
;	end if
; end if


;12����word��Ҳ����1 2λ��1����1λ��2����2λ
; if bit12 = 0 then
cmp int [ ScreenCapture_ColorTranslate_Catch_16Bit_1 ], 0
JPC NZ ScreenCapture_ColorCover_Else_12:

ld int [ ScreenCapture_ColorTranslate_Catch_16Bit_1 ], 2113

jmp ScreenCapture_ColorCover_EndIf_12:
; else
ScreenCapture_ColorCover_Else_12:

	;��һλ
	; if bite1 = 0 then
	cmp byte [ ScreenCapture_ColorTranslate_Catch_16Bit_1 ], 0
	JPC NZ ScreenCapture_ColorCover_Else_1:
	
	ld byte [ ScreenCapture_ColorTranslate_Catch_16Bit_1 ], 1
	
	jmp ScreenCapture_ColorCover_EndIf_12:
	; else if bite2 = 0 then
	ScreenCapture_ColorCover_Else_1:

	cmp byte [ ScreenCapture_ColorTranslate_Catch_16Bit_2 ], 0
	JPC NZ ScreenCapture_ColorCover_EndIf_12:
	
	ld byte [ ScreenCapture_ColorTranslate_Catch_16Bit_2 ], 8
	
ScreenCapture_ColorCover_EndIf_12:



;'��ͬ����������
ScreenCapture_ColorTranslate_ColorEqual:

ld int r0, [ ScreenCapture_ColorTranslate_Catch_16Bit_1 ]

ret

;//=============��ɫת������====Lib �� BMP=================//
ScreenCapture_Color_Tranform_LIB:

ld byte r1, [ ScreenCapture_ColorTranslate_Catch_Red ]	;[ ScreenCapture_ColorTranslate_Catch_Blue ]
ld byte r2, [ ScreenCapture_ColorTranslate_Catch_Green ]
ld byte r3, [ ScreenCapture_ColorTranslate_Catch_Blue ]	;[ ScreenCapture_ColorTranslate_Catch_Red ]

cal int Div r1, 8
cal int Div r2, 4	;G6
cal int Div r3, 8

cal int mul r2, 32
cal int mul r3, 2048

ret

ScreenCapture_Color_Tranform_BMP:

ld byte r1, [ ScreenCapture_ColorTranslate_Catch_Red ]
ld byte r2, [ ScreenCapture_ColorTranslate_Catch_Green ]
ld byte r3, [ ScreenCapture_ColorTranslate_Catch_Blue ]


cal int Div r1, 8
cal int Div r2, 8
cal int Div r3, 8

cal int mul r2, 32
cal int mul r3, 1024

ret

;//=============���еĳ�ʼ��=====================//
ScreenCapture_CommonInitialization:

;��ʼ������ ����ȷ��ֻ����һ��
ld int [ ScreenCapture_Paramater_1 ], [ vint_ScrP_page ]

;��������ƫ��
ld int [ vint_Scrp_DataOffSet ], ScreenCapture_Catch:

;��������б���һ��
ld int r0, [ vint_ScrP_wid ]
cal int mul r0, 2

ld int [ vint_Scrp_Save_PreLine ], 4095
cal int div [ vint_Scrp_Save_PreLine ], r0

endasm
'����Ϊ���ļ���ʽ
if ScrP_BMP_FileName$ = "" then

ScrP_FileName$ = "ScreenPrint.lib"
asm
ld int [ ScreenCapture_SaveAs_TYPE ], ScreenCapture_SaveAs_lib
ld int [ ScreenCapture_Color_Tranform_TYPE ], ScreenCapture_Color_Tranform_lib
ld int [ ScreenCapture_MainProcess_TYPE ], ScreenCapture_MainProcess_lib
endasm

else
ScrP_FileName$ = ScrP_BMP_FileName$ + ".bmp"
asm
ld int [ ScreenCapture_SaveAs_TYPE ], ScreenCapture_SaveAs_bmp
ld int [ ScreenCapture_Color_Tranform_TYPE ], ScreenCapture_Color_Tranform_bmp
ld int [ ScreenCapture_MainProcess_TYPE ], ScreenCapture_MainProcess_bmp
endasm

end if

asm
;����ͷ�ļ�������д��λ��
call [ ScreenCapture_SaveAs_TYPE ]

ret


	;//=============һ�������ɫ�������=================//
	ScreenCapture_OnePixel_Proc:
	
	;�����ǵ����~
	;��һ��ŵ��˳�ʼ���д���
	;'ld int [ ScreenCapture_Paramater_1 ], [ vint_ScrP_page ]
	ld int [ ScreenCapture_Paramater_2 ], [ vint_ScrP_x ]
	;��һ���Ѿ��ŵ�����ѭ���д��� �ӿ��ٶ�
	;' ld int [ ScreenCapture_Paramater_3 ], [ vint_ScrP_y ]
	ld int r3, ScreenCapture_Paramater_3
	OUT 25,0
	
	ld int r0, r3

	call ScreenCapture_ColorCover_16Bit
	
	ld int r1, [ vint_Scrp_DataOffSet ]

	ld int [ r1 ], r0

	ret


;//=============����һ�εĹ���=================//
ScreenCapture_OnePixel_Save_Proc:

ld int r1, [ vint_ScrP_y ]

;'if ( ScrP_y mod PreLine ) = 0 then
cal int mod r1, [ vint_Scrp_Save_PreLine ]
cmp int r1, 0
jpc NZ ScreenCapture_Main_Save_EndIf:

;��ʱָ������һ������Ϊ����β�ĳ��ȣ�����д��0�ں����ֹ����
ld int r1, [ vint_Scrp_DataOffSet ]
ld int [ r1 ], 0

;����
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, ScreenCapture_Catch

out 51, 18

;��������ָ��
ld int [ vint_Scrp_DataOffSet ], ScreenCapture_Catch


;ָ���һ�ֽ�
; loc( 1) - 1
ld int r3, [ vint_ScrP_FileHandle ]
out 54, 0

;seek
ld int r2, [ vint_ScrP_FileHandle ]
cal int add r3, - 1
out 55, 16

;'end if
ScreenCapture_Main_Save_EndIf:


ret

;//=============��Ҫ�Ľ�ͼ����----LIB=================//
ScreenCapture_MainProcess_LIB:



;'�������ѭ�����д��������ģ�����ȫ�������

;'��������ǽ�ͼ���ο��ƫ��
cal int add [ vint_ScrP_Hgt ], [ vint_ScrP_src_y ]
cal int add [ vint_ScrP_wid ], [ vint_ScrP_src_x ]

;'ScrP_y = src_y 
;'while ScrP_y < Hgt

ld int [ vint_ScrP_y ], [ vint_ScrP_src_y ]

;' while ScrP_Y < Hgt
ScreenCapture_Main_Y_Bend_LIB:
cmp int [ vint_ScrP_Y ], [ vint_ScrP_Hgt ]
jpc AE ScreenCapture_Main_Y_Wend_LIB:


	;'ScrP_x = src_x 
	ld int [ vint_ScrP_x ], [ vint_ScrP_src_x ]
	
	; 'while ScrP_x < Wid
	ScreenCapture_Main_X_Bend_LIB:
	cmp int [ vint_ScrP_x ], [ vint_ScrP_wid ]
	jpc AE ScreenCapture_Main_X_Wend_LIB:
	

	call ScreenCapture_OnePixel_Proc:
	
	;'����ƫ��+2
	cal int add [ vint_Scrp_DataOffSet ], 2
	; 'ScrP_x ++
	cal int add [ vint_ScrP_x ], 1
	
	;'Wend
	jmp ScreenCapture_Main_X_Bend_LIB:
	ScreenCapture_Main_x_Wend_LIB:


;'ScrP_y = ScrP_y + 1

cal int add [ vint_ScrP_y ], 1
;'���־��� Srcp_Y�Ƕ���ĸо�
;'������ֵ
ld int [ ScreenCapture_Paramater_3 ], [ vint_ScrP_y ]


;'�ж��Ƿ񴢴�
call ScreenCapture_OnePixel_Save_Proc:

;'wend
jmp ScreenCapture_Main_Y_Bend_LIB:
ScreenCapture_Main_Y_Wend_LIB:


call ScreenCapture_MainProcess_Last:

ret


;//=============��Ҫ�Ľ�ͼ����----BMP=================//
ScreenCapture_MainProcess_BMP:



;'�������ѭ�����д��������ģ�����ȫ�������

;'bmp 4bit  ����
ld int [ scrp_i ], [ vint_ScrP_wid ]
cal int mod [ scrp_i ], 2


'cal int add [ vint_ScrP_src_y ], 1 
;'��������ǽ�ͼ���ο��ƫ��
cal int add [ vint_ScrP_Hgt ], [ vint_ScrP_src_y ]
cal int add [ vint_ScrP_wid ], [ vint_ScrP_src_x ]



;'ScrP_y = src_y
;'while ScrP_y < Hgt

ld int [ vint_ScrP_y ], [ vint_ScrP_Hgt ]
;'����
cal int add [ vint_ScrP_y ], - 1

;' while ScrP_Y < Hgt
ScreenCapture_Main_Y_Bend_BMP:
cmp int [ vint_ScrP_Y ], [ vint_ScrP_src_y ]
jpc B ScreenCapture_Main_Y_Wend_BMP:


	;'ScrP_x = src_x 
	ld int [ vint_ScrP_x ], [ vint_ScrP_src_x ]
	
	; 'while ScrP_x < Wid
	ScreenCapture_Main_X_Bend_BMP:
	cmp int [ vint_ScrP_x ], [ vint_ScrP_wid ]
	jpc AE ScreenCapture_Main_X_Wend_BMP:
	
	
	
	call ScreenCapture_OnePixel_Proc:

	;'����ƫ��+2
	cal int add [ vint_Scrp_DataOffSet ], 2
	; 'ScrP_x ++
	cal int add [ vint_ScrP_x ], 1
	
	;'Wend
	jmp ScreenCapture_Main_X_Bend_BMP:
	ScreenCapture_Main_x_Wend_BMP:

cmp int [ scrp_i ], 0
jpc z ScreenCapture_BMP_Spc_Deal_End:

ld int r1, [ vint_Scrp_DataOffSet ]
ld int [ r1 ], 65535
cal int add [ vint_Scrp_DataOffSet ], 2

ScreenCapture_BMP_Spc_Deal_End:

;'ScrP_y = ScrP_y + 1
cal int add [ vint_ScrP_y ], - 1
;'���־��� Srcp_Y�Ƕ���ĸо�
;'������ֵ
ld int [ ScreenCapture_Paramater_3 ], [ vint_ScrP_y ]


;'�ж��Ƿ񴢴�
call ScreenCapture_OnePixel_Save_Proc:

;'wend
jmp ScreenCapture_Main_Y_Bend_BMP:
ScreenCapture_Main_Y_Wend_BMP:


call ScreenCapture_MainProcess_Last:

ret

;//==============ɨβ����=================//
ScreenCapture_MainProcess_Last:
;'����ɨβ���� ���ܻ�����һ����Ч�ַ�
;�����дһ��
ld int r1, [ vint_Scrp_DataOffSet ]
ld int [ r1 ], 0
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, ScreenCapture_Catch

out 51, 18

;�ر��ļ�
out 49, [ vint_ScrP_FileHandle ]

ret


ScreenCapture_SaveAs_LIB:
;=================================
;======//�ļ���ʼ��������//=======
;=================================
;Ϊ�˼�������µĽ�ͼ���Ƿ����ļ�ĩβ
;���ļ�
;open
ld int r0, 1
ld int r1, [ vint_ScrP_FileHandle ]
ld int r3, [ vstr_ScrP_FileName ]
out 48, 0

;����Ҫ˵���£������ɵ�lib�У�����ǰ��Ԥ��λ�ӣ����Ž�ͼ�ġ�Ԥ���Ķ���Ҳ���ǿ�
;�ʼ�յ�lib�ж��
;��ȡһ���ж���ͼƬ
;get #, Scrp_i
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
out 50, 16
ld int [ Scrp_i ], r3

;û���ļ���ʱ�� r3 < 0
;�����������û��lib�ļ����������Ϊ����ֻ��ǰ����һ��οյĲ��ܴ�����ͼ



;seek #, 0
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 0
out 55, 16

;������ĺ��������
cal int add [ Scrp_i ], 1
;put
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, [ Scrp_i ]
out 51, 16

;��ȡ�ļ�����
;lof
ld int r3, [ vint_ScrP_FileHandle ]
out 53, 0
ld int [ Scrp_j ], r3

;seek #, ��ǰ�ŵ�ƫ��λ��
cal int mul [ Scrp_i ], 4

ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, [ Scrp_i ]
out 55, 16


;����ƫ��
;put
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, [ Scrp_j ]
out 51, 16



;�ƶ����ļ�ĩβ
;seek #, ��ǰ�ŵ�ƫ��λ��
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, [ Scrp_j ]
out 55, 16

;�����ļ�ͷ
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 153612
out 51, 16

;�����С
ld int [ ScreenCapture_Init_Bit1 ], [ vint_ScrP_wid ]
ld int [ ScreenCapture_Init_Bit2 ], [ vint_ScrP_hgt ]
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, [ ScreenCapture_Init_Bit1 ]
out 51, 16

;ָ�� + 8
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 0
out 51, 16

ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 0
out 51, 16

;���ڵ��ļ�ƫ�ƾ��Ǹ�д���ļ��ĵط���ScrP_FileOffset
ld int r3, [ vint_ScrP_FileHandle ]
out 53, 0
ld int [ vint_ScrP_FileOffset ], r3

ret

;//===========�洢ΪBMP�ļ�===============//
;����ͷ�ļ�
ScreenCapture_SaveAs_BMP:
;open
ld int r0, 1
ld int r1, [ vint_ScrP_FileHandle ]
ld int r3, [ vstr_ScrP_FileName ]
out 48, 0

'BM
;put
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 19778
out 51, 16

;seek #, 2
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 2
out 55, 16

;'�����ļ���С   һ����С����scrp_i������Ҫʹ��
ld int r1, [ vint_ScrP_wid ]
ld int r3, [ vint_ScrP_hgt ]

cal int mul r3, r1
cal int mul r3, 2

ld int [ scrp_i ], r3

cal int add r3, 54
;����
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647

out 51, 16
;'����BBMP ��Ϊ�����ļ��ı�ʶ
ld int r3, 1347240514
out 51, 16

;'�����׼��ͷ�ļ�����
ld int r3, 54
out 51, 16

;'�����׼��ͷ�ļ���С
ld int r3, 40
out 51, 16

;'�����
ld int r3, [ vint_ScrP_wid ]
out 51, 16

;'�����
ld int r3, [ vint_ScrP_Hgt ]
out 51, 16

;'����һЩ������Ϣ ���ֻռ2byte
ld int r3, 1
out 51, 16

;seek #, 28
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 28
out 55, 16

;'������ɫ��ʽ 16bit ���ֻռ2byte
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 16
out 51, 16

;seek #, 30
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 30
out 55, 16

;'����ѹ������ ��ѹ��
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 0
out 51, 16

;'����ͼ�����ݳ���
ld int r3, [ scrp_i ]
out 51, 16

;'����
ld int r3, 2834
out 51, 16

;'����
ld int r3, 2834
out 51, 16

;'����
ld int r3, 0
out 51, 16

;'����
out 51, 16

ret
Scrp_QingWuShi:
endasm

