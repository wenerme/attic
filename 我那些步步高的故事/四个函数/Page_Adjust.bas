setlcd( 240, 320)

declare function getInput()
declare function PageAdjust( hPage)
'//��ȡ������Ϣ
function getInput()
'Block
'//����
'��ֵ����
Dim shared G_key_up, G_key_down, G_key_left, G_key_right
Dim shared G_key_escape, G_key_enter
Dim shared G_touch_x, G_touch_y	'�������X Y
Dim shared G_touch_ID	'���������idֵ
Dim shared G_Func_calTouchId, G_User_Inkey
asm
'==/////=========== �����
ld int r3,38
out 34,0
ld int [vint_g_key_up],r3
ld int r3,40
out 34,0
ld int [vint_g_key_down],r3
ld int r3,37
out 34,0
ld int [vint_g_key_left],r3
ld int r3,39
out 34,0
ld int [vint_g_key_right],r3
ld int r3,13
out 34,0
'//==============������
ld int [vint_g_key_enter],r3
ld int r3,27
out 34,0
ld int [vint_g_key_escape],r3

endasm
'==/////===========����
if G_User_Inkey < 0 then
	G_touch_x = getpenposx( G_User_Inkey)
	G_touch_y = getpenposy( G_User_Inkey)
	G_touch_id = -1
	asm
	;'���㴥��
	call [ vint_G_Func_calTouchId ]
	
	endasm
	
else
	G_touch_x = -1
	G_touch_y = -1
	G_touch_id = -1
end if


end function
asm
jmp G_Func_calTouchId_WUSHI:
G_Func_calTouchId_UNDO:
ret
G_Func_calTouchId_WUSHI:
endasm
'EndBlock

IF GetEnv!() = Env_SIM Then
	SYS_Fe$ = ".rlb"
Else
	SYS_Fe$ = ".lib"
End IF


'//=========PageAdjust==========//
'//=========ҳ���������==========//
'���� Wener
'��̳Id a3160586 (club.eebbk.com   �����)
'QQ 514403150
function PageAdjust( hPage)
'Block
'/ҳ����'
dim shared PageAd_Page_Src, PageAd_Page_Buff, PageAd_Page_Buff_Catch
dim shared PageAd_Passage_R, PageAd_Passage_G, PageAd_Passage_B
dim shared PageAd_Mix_Red, PageAd_Mix_Green, PageAd_Mix_Blue, PageAd_Mix_Light	'ÿ����ɫ������ֵ
'/״̬��Ϣ
dim shared PageAd_Show_Passage	'���Ϊ0 ����ʾrgb  1��ʾrͨ�� 2G 3B
dim shared PageAd_Show_LR, PageAd_Show_TB	'�Ƿ��÷����
dim shared PageAd_Show_Gray	'�Ƿ�ҶȻ�
dim shared PageAd_Show_Scan_Type '�鿴��ģʽ 1 2 3 
dim shared PageAd_Main_Max_X, PageAd_Main_Max_Y
dim shared PageAd_Pic_Menu, PageAd_Pic_Menu_Pr
dim shared PageAd_i, PageAd_Sys_Over

PageAd_Page_Buff_Catch = createpage() 'buffҳ��Ļ��� �����ֱ�����ģʽ ֻ��Ҫ�������ҳ��ͺ���
PageAd_Page_Buff 	= createpage()
PageAd_Page_Src 	= hPage

PageAd_Pic_Menu 	= loadres( "Page_AD" + SYS_Fe$, 1)
PageAd_Pic_Menu_Pr 	= loadres( "Page_AD" + SYS_Fe$, 2)

'Ĭ�ϵ���ʾͨ��
PageAd_Show_Passage = 0
'Ĭ�ϵ�������ʾģʽ ȫ��
PageAd_Show_Scan_Type = 3

PageAd_Main_Max_X = 240
PageAd_Main_Max_Y = 320
asm
'��������
ld int [ vint_G_Func_calTouchId ], PageAd_CalTouch
'��ʼ��
call PageAd_Initialization
'������ѭ��
call PageAd_Main_While
endasm

'�ͷ���Դ
deletepage( PageAd_Page_Buff)
deletepage( PageAd_Page_Buff_Catch)

freeres( PageAd_Pic_Menu )
freeres( PageAd_Pic_Menu_Pr )
end function

'//=====================��ಿ��=========================//
'Block
asm
jmp PageAd_QingWuShiWo:

'//====================������ѭ��=======================//
PageAd_Main_While:
'Block
ld int [ vint_PageAd_Sys_Over ], 0

'��һ����Ҫ����ѭ��
ld int [ vint_G_touch_ID ], 1
'�����һ�ε�Waitkey
jmp PageAd_Skip_The_First_Waitkey
endasm
while not PageAd_Sys_Over
G_User_Inkey = waitkey()
getInput()
	
	'����ֵ
	if G_key_escape then
		PageAd_Mix_Red 		= 0
		PageAd_Mix_Green 	= 0
		PageAd_Mix_Blue 	= 0
		PageAd_Mix_Light 	= 0
		G_touch_ID = 1	'��Ҫ���� �൱�ڴ�����ͼ
	'ȷ��
	else if G_key_enter then
		vasm(" call PageAd_Menu_6")
	end if
	
	asm
	PageAd_Skip_The_First_Waitkey:
	
	'�ں��� ������뾭����һ�� ����ֱ������IdΪ - 1
	cmp int [ vint_G_touch_ID ], - 1
	jpc z PageAd_Main_Process_NotRun:
		call PageAd_Main_Process_Circulation
	PageAd_Main_Process_NotRun:
	
	call PageAd_UI_Construct
	endasm
	
flippage( PageAd_Page_Buff )
wend

asm
ret
'EndBlock
;'//====================��ʼ��=======================//
data PageAd_Initialization_Temp_rs dword 0
PageAd_Initialization:
'Block
'/��ʼ�˵���ת��
ld int [ PageAd_Menu_Jump_0 ], PageAd_Menu_0
ld int [ PageAd_Menu_Jump_1 ], PageAd_Menu_1
ld int [ PageAd_Menu_Jump_2 ], PageAd_Menu_2
ld int [ PageAd_Menu_Jump_3 ], PageAd_Menu_3
ld int [ PageAd_Menu_Jump_4 ], PageAd_Menu_4
ld int [ PageAd_Menu_Jump_5 ], PageAd_Menu_5
ld int [ PageAd_Menu_Jump_6 ], PageAd_Menu_6
ld int [ PageAd_Menu_Jump_7 ], PageAd_Menu_7
ld int [ PageAd_Menu_Jump_8 ], PageAd_Menu_8
'/��ʼPixel��hpage  ���ֻ������ɵ�ʱ��Ÿ���  ��ΪĿ��ҳ��ľ��
ld int [ PageAd_Pixel_Param_hPage ], [ vint_PageAd_Page_Buff ]

'/��ʼ ������ɫ��Ϣ
ld int [ PageAd_ReadPixel_Param_hPage ], [ vint_PageAd_Page_Src ]
'��Ϊ���õ�Push ���Ծʹ����һ�п�ʼ��ȡ
ld int [ PageAd_Initialization_Temp_rs ], rs
ld int rs, PageAd_Color_Chunk_Last

ld int [ PageAd_ReadPixel_Param_Y ], 319
'while
PageAd_Init_While_Y:
cmp int [ PageAd_ReadPixel_Param_Y ], 0
Jpc B PageAd_Init_Wend_Y
	
	
	ld int [ PageAd_ReadPixel_Param_X ], 239
	'while һ�δ���4��
	PageAd_Init_While_X:
	cmp int [ PageAd_ReadPixel_Param_X ], 0
	Jpc B PageAd_Init_Wend_X
	
	'1
	'��Push �ҾͲ����Լ���ָ���� 
	ld int r3, PageAd_ReadPixel_Parameter
	OUT 25,0
	'Push��
	push r3
	cal int add [ PageAd_ReadPixel_Param_X ], - 1
	'2
	ld int r3, PageAd_ReadPixel_Parameter
	OUT 25,0
	push r3
	cal int add [ PageAd_ReadPixel_Param_X ], - 1
	'3
	ld int r3, PageAd_ReadPixel_Parameter
	OUT 25,0
	push r3
	cal int add [ PageAd_ReadPixel_Param_X ], - 1
	'4
	ld int r3, PageAd_ReadPixel_Parameter
	OUT 25,0
	push r3
	cal int add [ PageAd_ReadPixel_Param_X ], - 1

	'wend
	jmp PageAd_Init_While_X
	PageAd_Init_Wend_X:

cal int add [ PageAd_ReadPixel_Param_Y ], - 1
'wend
jmp PageAd_Init_While_Y
PageAd_Init_Wend_Y:

'�ָ�ջָ��
ld int rs , [ PageAd_Initialization_Temp_rs ]

ret
'EndBlock

;'//====================�����б�=======================//
'Block
;'//����ɫ�ĵط�  320 * 240 * 4�Ĵ�С
PageAd_Color_Chunk:
.block 307196 0
PageAd_Color_Chunk_Last:
.block 4 0
'pixel( hPage, X, Y, color) ��������б��൱����ר���������̵�
PageAd_Pixel_Parameter:
PageAd_Pixel_Param_4:
PageAd_Pixel_Param_Color:
PageAd_Main_CurColor:
'������RGB  ����bb��bgr��  ��Ϊд���ʱ���Ǹ���λ��ǰ����ʲô���µ� ���������ɫ��pixel�� ����û����
PageAd_Main_CurColor_Red:
.block 1 0
PageAd_Main_CurColor_Green:
.block 1 0
PageAd_Main_CurColor_Blue:
.block 2 0
PageAd_Main_CurY:
PageAd_Pixel_Param_Y:
PageAd_Pixel_Param_3:
.block 4 0
PageAd_Main_CurX:
PageAd_Pixel_Param_X:
PageAd_Pixel_Param_2:
.block 4 0
PageAd_Pixel_Param_hPage:
PageAd_Pixel_Param_1:
.block 4 0

'ReadpixelPixel( hPage, X, Y)
PageAd_ReadPixel_Param_4:
.block 4 0
PageAd_ReadPixel_Parameter:
PageAd_ReadPixel_Param_Y:
PageAd_ReadPixel_Param_3:
.block 4 0
PageAd_ReadPixel_Param_X:
PageAd_ReadPixel_Param_2:
.block 4 0
PageAd_ReadPixel_Param_hPage:
PageAd_ReadPixel_Param_1:
.block 4 0

PageAd_showpic_Paramater:
PageAd_showpic_Paramater_9:
data PageAd_showpic_mode dword 1 '��Ϊ������˵ģʽ����1

'/showpic SHOWPIC(PAGE,PIC,DX,DY,W,H,X,Y,MODE)
PageAd_showpic_Paramater_8:
PageAd_showpic_SrcY:
.block 4 0
PageAd_showpic_Paramater_7:
PageAd_showpic_SrcX:
.block 4 0
PageAd_showpic_Paramater_6:
PageAd_showpic_Hgt:
.block 4 0
PageAd_showpic_Paramater_5:
PageAd_showpic_Wid:
.block 4 0
PageAd_showpic_Paramater_4:
PageAd_showpic_DesY:
.block 4 0
PageAd_showpic_Paramater_3:
PageAd_showpic_Desx:
.block 4 0
PageAd_showpic_Paramater_2:
PageAd_showpic_Pic:
.block 4 0
PageAd_showpic_Paramater_1:
PageAd_showpic_Page:
.block 4 0

'OUT 23,0 fillpage�Ķ˿�
PageAd_FILLPAGE_Paramater:
PageAd_FILLPAGE_Paramater_6:
.block 4 0
PageAd_FILLPAGE_Paramater_5:
.block 4 0
PageAd_FILLPAGE_Paramater_4:
.block 4 0
PageAd_FILLPAGE_Paramater_3:
.block 4 0
PageAd_FILLPAGE_Paramater_2:
.block 4 0
PageAd_FILLPAGE_Paramater_1:
.block 4 0

PageAd_Menu_Jump_Table:
PageAd_Menu_Jump_0:
.block 4 0
PageAd_Menu_Jump_1:
.block 4 0
PageAd_Menu_Jump_2:
.block 4 0
PageAd_Menu_Jump_3:
.block 4 0
PageAd_Menu_Jump_4:
.block 4 0
PageAd_Menu_Jump_5:
.block 4 0
PageAd_Menu_Jump_6:
.block 4 0
PageAd_Menu_Jump_7:
.block 4 0
PageAd_Menu_Jump_8:
.block 4 0
'EndBlock

;'//===================����UI========================//
PageAd_UI_Construct:
'Block

'[ vint_PageAd_Page_Buff ]
ld int [ PageAd_showpic_Paramater_1 ], [ vint_PageAd_Page_Buff ]
ld int [ PageAd_showpic_Paramater_2 ], [ vint_PageAd_Pic_Menu ]
ld int [ PageAd_showpic_Paramater_3 ], 5	'�˵�����Ļ�ϵ�ƫ����5 5
ld int [ PageAd_showpic_Paramater_4 ], 5
ld int [ PageAd_showpic_Paramater_5 ], 80
ld int [ PageAd_showpic_Paramater_6 ], 110
ld int [ PageAd_showpic_Paramater_7 ], 0
ld int [ PageAd_showpic_Paramater_8 ], 0
ld int r3, PageAd_showpic_Paramater
out 20, 0

'/��ʾ���µ�״̬
'Block
ld int [ PageAd_showpic_Paramater_2 ], [ vint_PageAd_Pic_Menu_pr ]

cmp int [ vint_PageAd_Show_TB ], 0
jpc z PageAd_UI_Construct_NotTB:
	ld int r1, 0
	call PageAd_UI_Construct_Show_Menu_Pr_By_ID
PageAd_UI_Construct_NotTB:

cmp int [ vint_PageAd_Show_LR ], 0
jpc z PageAd_UI_Construct_NotLR:
	ld int r1, 1
	call PageAd_UI_Construct_Show_Menu_Pr_By_ID
PageAd_UI_Construct_NotLR:

cmp int [ vint_PageAd_Show_Gray ], 0
jpc z PageAd_UI_Construct_NotGray:
	ld int r1, 2
	call PageAd_UI_Construct_Show_Menu_Pr_By_ID
PageAd_UI_Construct_NotGray:
'���ģʽ
ld int r1, [ vint_PageAd_Show_Scan_Type ]
cal int add r1, 2
call PageAd_UI_Construct_Show_Menu_Pr_By_ID
'ͨ����ѡ��ť����ʾ
'1��ʾrͨ�� 2G 3B


	ld int [ PageAd_showpic_Paramater_3 ], 8	'5 + 3 = 8
	'ld int [ PageAd_showpic_Paramater_4 ], 5
	ld int [ PageAd_showpic_Paramater_5 ], 10
	ld int [ PageAd_showpic_Paramater_6 ], 10
	ld int [ PageAd_showpic_Paramater_7 ], 3
	'ld int [ PageAd_showpic_Paramater_8 ], 0
	
	ld int [ PageAd_showpic_Paramater_8 ], [ vint_PageAd_Show_Passage ]
	cal int mul [ PageAd_showpic_Paramater_8 ], 10
	cal int add [ PageAd_showpic_Paramater_8 ], 5
	
	ld int [ PageAd_showpic_Paramater_4 ], [ PageAd_showpic_Paramater_8 ]
	cal int add [ PageAd_showpic_Paramater_4 ], 5
	
	ld int r3, PageAd_showpic_Paramater
	out 20, 0

'EndBlock
'/��ʾ��ǰ�� L R G B ֵ
'Block
'FILLPAGE(PAGE,X,Y,WID,HGT,COLOR)
'x ƫ�� 15 ����Ϊ 60 ��ʾ�Ŀ��� 1 * 4
ld int [ PageAd_FILLPAGE_Paramater_1 ], [ vint_PageAd_Page_Buff ]

ld int [ PageAd_FILLPAGE_Paramater_4 ], 1
ld int [ PageAd_FILLPAGE_Paramater_5 ], 4
ld int [ PageAd_FILLPAGE_Paramater_6 ], 10576398
'15 + 30 + 5 = 50 '5 + 5 + 3 = 13
'L
ld int [ PageAd_FILLPAGE_Paramater_2 ], 50
ld int [ PageAd_FILLPAGE_Paramater_3 ], 13
cal int add [ PageAd_FILLPAGE_Paramater_2 ], [ vint_PageAd_Mix_Light ]
ld int r3,  PageAd_FILLPAGE_Paramater
OUT 23,0
'R
ld int [ PageAd_FILLPAGE_Paramater_2 ], 50
ld int [ PageAd_FILLPAGE_Paramater_3 ], 23
cal int add [ PageAd_FILLPAGE_Paramater_2 ], [ vint_PageAd_Mix_Red ]
'ld int r3,  PageAd_FILLPAGE_Paramater
OUT 23,0
'G
ld int [ PageAd_FILLPAGE_Paramater_2 ], 50
ld int [ PageAd_FILLPAGE_Paramater_3 ], 33
cal int add [ PageAd_FILLPAGE_Paramater_2 ], [ vint_PageAd_Mix_Green ]
'ld int r3,  PageAd_FILLPAGE_Paramater
OUT 23,0
'B
ld int [ PageAd_FILLPAGE_Paramater_2 ], 50
ld int [ PageAd_FILLPAGE_Paramater_3 ], 43
cal int add [ PageAd_FILLPAGE_Paramater_2 ], [ vint_PageAd_Mix_Blue ]
'ld int r3,  PageAd_FILLPAGE_Paramater
OUT 23,0
'EndBlock

ret

data PageAd_UI_Construct_Show_Menu_Pr_Wid dword 0
data PageAd_UI_Construct_Show_Menu_Pr_Hgt dword 0
'//��ʾ����Ĳ˵� ���� r1

PageAd_UI_Construct_Show_Menu_Pr_By_ID:
'Block
' 012
' 345
' 678
'ͼ���� 24 * 24 ��
ld int [ PageAd_UI_Construct_Show_Menu_Pr_Wid ], r1
cal int mod [ PageAd_UI_Construct_Show_Menu_Pr_Wid ], 3
cal int mul [ PageAd_UI_Construct_Show_Menu_Pr_Wid ], 24

ld int [ PageAd_UI_Construct_Show_Menu_Pr_hgt ], r1
cal int div [ PageAd_UI_Construct_Show_Menu_Pr_Hgt ], 3
cal int mul [ PageAd_UI_Construct_Show_Menu_Pr_Hgt ], 24

'ƫ��
cal int add [ PageAd_UI_Construct_Show_Menu_Pr_Wid ], 3
cal int add [ PageAd_UI_Construct_Show_Menu_Pr_Hgt ], 41	'�����ֵ�д�����

ld int [ PageAd_showpic_Paramater_7 ], [ PageAd_UI_Construct_Show_Menu_Pr_Wid ]
ld int [ PageAd_showpic_Paramater_8 ], [ PageAd_UI_Construct_Show_Menu_Pr_Hgt ]

ld int [ PageAd_showpic_Paramater_3 ], [ PageAd_UI_Construct_Show_Menu_Pr_Wid ]
ld int [ PageAd_showpic_Paramater_4 ], [ PageAd_UI_Construct_Show_Menu_Pr_Hgt ]
'ƫ��
cal int add [ PageAd_showpic_Paramater_3 ], 5
cal int add [ PageAd_showpic_Paramater_4 ], 5

ld int [ PageAd_showpic_Paramater_5 ], 24
ld int [ PageAd_showpic_Paramater_6 ], 24

ld int r3, PageAd_showpic_Paramater
out 20, 0

ret
'EndBlock
'EndBlock
data PageAd_Main_Offset dowrd 0
data PageAd_Main_CurPos dword 0
data PageAd_Main_Red_temp dword 0
data PageAd_Main_Green_temp dword 0
data PageAd_Main_Blue_temp dword 0
;'//====================��Ҫ����ѭ��=======================//
PageAd_Main_Process_Circulation:
'Block

'����ԭҳ����Ϊ����
ld int r2, [ vint_PageAd_Page_Buff ]
ld int r3, [ vint_PageAd_Page_Src ]
OUT 22,0
'��ͼ���Ǵ����Ͽ�ʼ  ��max_x��Ϊ240��ʱ�� Ҫ���м�ƫ��
ld int [ PageAd_Main_CurPos ], PageAd_Color_Chunk
'����ƫ��
ld int [ PageAd_Main_Offset ], 240
cal int sub [ PageAd_Main_Offset ], [ vint_PageAd_Main_Max_X ]
cal int mul [ PageAd_Main_Offset ], 4
'��ʼ��ЩҪ����
'/����ɫ�Ĵ���
'Block
'�������ȶ�Rgb�Ľ����˸ı� ����Ҫ�Ȼ���rGB Ȼ�������ٻָ�
ld int [ PageAd_Main_Red_temp ], [ vint_PageAd_Mix_Red ]
ld int [ PageAd_Main_Green_temp ], [ vint_PageAd_Mix_Green ]
ld int [ PageAd_Main_Blue_temp ], [ vint_PageAd_Mix_Blue ]
'/�����ȵĴ���
cal int add [ vint_PageAd_Mix_Red ], [ vint_PageAd_Mix_Light ]
cal int add [ vint_PageAd_Mix_Green ], [ vint_PageAd_Mix_Light ]
cal int add [ vint_PageAd_Mix_Blue ], [ vint_PageAd_Mix_Light ]
'r
cmp int [ vint_PageAd_Mix_Red ], 0
jpc z PageAd_Show_NotDealRed:
	ld int [ PageAd_Pic_ColorAd_Red_Block ], [ PageAd_Pic_ColorAd_Red_Call ]
PageAd_Show_NotDealRed:
'g
cmp int [ vint_PageAd_Mix_Green ], 0
jpc z PageAd_Show_NotDealGreen:
	ld int [ PageAd_Pic_ColorAd_Green_Block ], [ PageAd_Pic_ColorAd_Green_Call ]
PageAd_Show_NotDealGreen:
'b
cmp int [ vint_PageAd_Mix_Blue ], 0
jpc z PageAd_Show_NotDealBlue:
	ld int [ PageAd_Pic_ColorAd_Blue_Block ], [ PageAd_Pic_ColorAd_Blue_Call ]
PageAd_Show_NotDealBlue:
'EndBlock

'/�Ƿ���ʾ��ͨ�� PageAd_Show_Passage���� 0-rgb 1-r 2-g 3-b
'Block
cmp int [ vint_PageAd_Show_Passage ], 0
jpc z PageAd_Show_Passage_RGB
	'r
	cmp int [ vint_PageAd_Show_Passage ], 1
	jpc nz PageAd_Show_Passage_NotRed:
		ld int [ PageAd_Pic_Show_Passage_Block ], [ PageAd_Pic_Show_Passage_Red_Call ]
	jmp PageAd_Show_Passage_Out
	PageAd_Show_Passage_NotRed:
	'g
	cmp int [ vint_PageAd_Show_Passage ], 2
	jpc nz PageAd_Show_Passage_NotGreen:
		ld int [ PageAd_Pic_Show_Passage_Block ], [ PageAd_Pic_Show_Passage_Green_Call ]
	jmp PageAd_Show_Passage_Out
	PageAd_Show_Passage_NotGreen:
	'b
	cmp int [ vint_PageAd_Show_Passage ], 3
	jpc nz PageAd_Show_Passage_NotBlue:
		ld int [ PageAd_Pic_Show_Passage_Block ], [ PageAd_Pic_Show_Passage_Blue_Call ]
	jmp PageAd_Show_Passage_Out
	PageAd_Show_Passage_NotBlue:
	
PageAd_Show_Passage_RGB:
PageAd_Show_Passage_Out:
'EndBlock

'/�Ƿ���
'Block
'left right
cmp int [ vint_PageAd_Show_LR ], 0
jpc z PageAd_Show_LR_Not

	ld int [ PageAd_Pic_LR_Block ], [ PageAd_Pic_LR_Call ]
	ld int [ PageAd_Pic_Coordinate_BackUp_Block ], [ PageAd_Pic_Coordinate_BackUp_Call ]
	ld int [ PageAd_Pic_Coordinate_Return_Block ], [ PageAd_Pic_Coordinate_Return_Call ]
	
PageAd_Show_LR_Not:
'top bottom
cmp int [ vint_PageAd_Show_TB ], 0
jpc z PageAd_Show_TB_Not

	ld int [ PageAd_Pic_TB_Block ], [ PageAd_Pic_TB_Call ]
	ld int [ PageAd_Pic_Coordinate_BackUp_Block ], [ PageAd_Pic_Coordinate_BackUp_Call ]
	ld int [ PageAd_Pic_Coordinate_Return_Block ], [ PageAd_Pic_Coordinate_Return_Call ]
	
PageAd_Show_TB_Not:
'EndBlock

'/�Ƿ�ҶȻ�
'Block
cmp int [ vint_PageAd_Show_Gray ], 0
jpc z PageAd_Show_Gray_not
	ld int [ PageAd_Pic_Gray_Block ], [ PageAd_Pic_Gray_Call ]
PageAd_Show_Gray_not:
'EndBlock
'/ѭ����ʼ
'Block
ld int [ PageAd_Pixel_Param_Y ], 0
'while
PageAd_Main_Process_While_Y:
cmp int [ PageAd_Pixel_Param_Y ], [ vint_PageAd_Main_Max_Y ]
jpc AE PageAd_Main_Process_Wend_Y


	ld int [ PageAd_Pixel_Param_X ], 0
	'while
	PageAd_Main_Process_While_X:
	cmp int [ PageAd_Pixel_Param_X ], [ vint_PageAd_Main_Max_X ]
	jpc AE PageAd_Main_Process_Wend_X
	
	'/���뵱ǰ��ɫ
	ld int r0, [ PageAd_Main_CurPos ]
	'/curColor Ҳ�ǵ���Pixel��color����
	ld int [ PageAd_Pixel_Param_Color ], [ r0 ]
	
	'//��ͼƬ�����ĵ�������
	'/���걸��
	PageAd_Pic_Coordinate_BackUp_block:
	.block 5 0
	'/����ɫ�Ĵ���
	PageAd_Pic_ColorAd_Red_Block:
	.block 5 0
	PageAd_Pic_ColorAd_Green_Block:
	.block 5 0
	PageAd_Pic_ColorAd_Blue_Block:
	.block 5 0
	'/�һ�ҳ��
	PageAd_Pic_Gray_Block:
	.block 5 0
	'/ֻ��ʾĳһͨ������ɫ
	PageAd_Pic_Show_Passage_Block:
	.block 5 0
	'/���ҵ���
	PageAd_Pic_LR_Block:
	.block 5 0
	'/���µ���
	PageAd_Pic_TB_Block:
	.block 5 0
	
	'/pixel ���������ɫ
	ld int r3, PageAd_Pixel_Parameter
	out 24, 0
	
	'/����ָ�
	PageAd_Pic_Coordinate_Return_Block:
	.block 5 0
	
	'��ɫλ�õ���
	cal int add [ PageAd_Main_CurPos ], 4
	cal int add [ PageAd_Pixel_Param_X ], 1
	'wend
	jmp PageAd_Main_Process_While_X
	PageAd_Main_Process_Wend_X:

'/�Ӳ���x��ƫ��
cal int add [ PageAd_Main_CurPos ], [ PageAd_Main_Offset ]
cal int add [ PageAd_Pixel_Param_Y ], 1
'wend
jmp PageAd_Main_Process_While_Y
PageAd_Main_Process_Wend_Y:
'EndBlock

'����ҳ��
ld int r2, [ vint_PageAd_Page_Buff_Catch ]
ld int r3, [ vint_PageAd_Page_Buff ]
OUT 22,0

ld int [ vint_PageAd_Mix_Red ]	, [ PageAd_Main_Red_temp ]
ld int [ vint_PageAd_Mix_Green ]	, [ PageAd_Main_Green_temp ]
ld int [ vint_PageAd_Mix_Blue ]	, [ PageAd_Main_Blue_temp ]
'����
ld int [ PageAd_Pic_Coordinate_BackUp_block ] , 0
ld int [ PageAd_Pic_ColorAd_Red_Block ]		 , 0
ld int [ PageAd_Pic_ColorAd_Green_Block ]	 , 0
ld int [ PageAd_Pic_ColorAd_Blue_Block ]	 , 0
ld int [ PageAd_Pic_Gray_Block ]			 , 0
ld int [ PageAd_Pic_Show_Passage_Block ]	 , 0
ld int [ PageAd_Pic_LR_Block ]				 , 0
ld int [ PageAd_Pic_TB_Block ]				 , 0
ld int [ PageAd_Pic_Coordinate_Return_Block ] , 0

ret
'EndBlock
;'//====================������=======================//
'Block
;'//====================��ͼƬ���лҶȴ���=======================//
PageAd_Pic_Gray:
'Block
'�Ҽ���ľ�����R G B ��ƽ��ֵ
ld int r0, 0
ld int r1, 0

ld byte r0, [ PageAd_Main_CurColor_Red ]
ld byte r1, [ PageAd_Main_CurColor_Green ]

cal int add r0, r1
ld byte r1, [ PageAd_Main_CurColor_Blue ]
cal int add r0, r1
cal int div r0, 3

ld byte [ PageAd_Main_CurColor_Red ], r0
ld byte [ PageAd_Main_CurColor_Green ], r0
ld byte [ PageAd_Main_CurColor_Blue ], r0

ret
PageAd_Pic_Gray_Call:
call PageAd_Pic_Gray
'EndBlock

;'//====================ֻ��ʾĳ��ͨ��=======================//
'������ PageAd_Pic_Show_Passage_ + color
'Block
PageAd_Pic_Show_Passage_Red:
'��
'Block
ld byte [ PageAd_Main_CurColor_Blue ], [ PageAd_Main_CurColor_Red ]
ld byte [ PageAd_Main_CurColor_Green ], [ PageAd_Main_CurColor_Red ]

ret
PageAd_Pic_Show_Passage_Red_Call:
call PageAd_Pic_Show_Passage_Red
'EndBlock
PageAd_Pic_Show_Passage_Green:
'��
'Block
ld byte [ PageAd_Main_CurColor_Blue ], [ PageAd_Main_CurColor_Green ]
ld byte [ PageAd_Main_CurColor_Red ], [ PageAd_Main_CurColor_Green ]

ret
PageAd_Pic_Show_Passage_Green_Call:
call PageAd_Pic_Show_Passage_Green
'EndBlock
PageAd_Pic_Show_Passage_Blue:
'��
'Block

ld byte [ PageAd_Main_CurColor_Red ], [ PageAd_Main_CurColor_Blue ]
ld byte [ PageAd_Main_CurColor_Green ], [ PageAd_Main_CurColor_Blue ]

ret
PageAd_Pic_Show_Passage_Blue_Call:
call PageAd_Pic_Show_Passage_Blue
'EndBlock
'EndBlock

;'//===================ĳһ��ɫ����========================//
'���� PageAd_Pic_ColorAd_ + color
'Block
PageAd_Pic_ColorAd_Red:
'Block
'����ֵ��Ϊ -30-0-30 ��ֵ
ld int r0, 0
ld byte r0, [ PageAd_Main_CurColor_Red ]
ld int r1, r0

cal int mul r0, [ vint_PageAd_Mix_Red ]
cal int div r0, 30
cal int add r1, r0
'���޺����޵����
cmp int r1, 255
jpc B PageAd_Pic_ColorAd_Red_NotOver
	ld int r1, 255
PageAd_Pic_ColorAd_Red_NotOver:

cmp int r1, 0
jpc A PageAd_Pic_ColorAd_Red_NotLow
	ld int r1, 0
PageAd_Pic_ColorAd_Red_NotLow:

ld byte [ PageAd_Main_CurColor_Red ], r1

ret
PageAd_Pic_ColorAd_Red_Call:
call PageAd_Pic_ColorAd_Red
'EndBlock
PageAd_Pic_ColorAd_Green:
'Block
ld int r0, 0
ld byte r0, [ PageAd_Main_CurColor_Green ]
ld int r1, r0

cal int mul r0, [ vint_PageAd_Mix_Green ]
cal int div r0, 30
cal int add r1, r0

cmp int r1, 255
jpc B PageAd_Pic_ColorAd_Green_NotOver
	ld int r1, 255
PageAd_Pic_ColorAd_Green_NotOver:

cmp int r1, 0
jpc A PageAd_Pic_ColorAd_Green_NotLow
	ld int r1, 0
PageAd_Pic_ColorAd_Green_NotLow:

ld byte [ PageAd_Main_CurColor_Green ], r1

ret
PageAd_Pic_ColorAd_Green_Call:
call PageAd_Pic_ColorAd_Green
'EndBlock
PageAd_Pic_ColorAd_Blue:
'Block
ld int r0, 0
ld byte r0, [ PageAd_Main_CurColor_Blue ]
ld int r1, r0

cal int mul r0, [ vint_PageAd_Mix_Blue ]
cal int div r0, 30
cal int add r1, r0

cmp int r1, 255
jpc B PageAd_Pic_ColorAd_Blue_NotOver
	ld int r1, 255
PageAd_Pic_ColorAd_Blue_NotOver:

cmp int r1, 0
jpc A PageAd_Pic_ColorAd_Blue_NotLow
	ld int r1, 0
PageAd_Pic_ColorAd_Blue_NotLow:

ld byte [ PageAd_Main_CurColor_Blue ], r1

ret
PageAd_Pic_ColorAd_Blue_Call:
call PageAd_Pic_ColorAd_Blue
'EndBlock
'EndBlock

data PageAd_Pic_Coordinate_Temp_X dword 0
data PageAd_Pic_Coordinate_Temp_Y dword 0
;'//===================������========================//
'Block
PageAd_Pic_LR:
'left right
'Block

ld int r0, 239
cal int sub r0, [ PageAd_Main_CurX ]
ld int [ PageAd_Main_CurX ], r0

ret
PageAd_Pic_LR_Call:
call PageAd_Pic_LR
'EndBlock

PageAd_Pic_TB:
'top bottom
'Block

ld int r0, 319
cal int sub r0, [ PageAd_Main_CurY ]
ld int [ PageAd_Main_CurY ], r0

ret
PageAd_Pic_TB_Call:
call PageAd_Pic_TB
'EndBlock

'/���걸��
PageAd_Pic_Coordinate_BackUp:
'Block
ld int [ PageAd_Pic_Coordinate_Temp_X ], [ PageAd_Main_CurX ]
ld int [ PageAd_Pic_Coordinate_Temp_Y ], [ PageAd_Main_CurY ]
ret
PageAd_Pic_Coordinate_BackUp_Call:
call PageAd_Pic_Coordinate_BackUp
'EndBlock

'/�ָ�����ֵ
PageAd_Pic_Coordinate_Return:
'Block
ld int [ PageAd_Main_CurX ], [ PageAd_Pic_Coordinate_Temp_X ]
ld int [ PageAd_Main_CurY ], [ PageAd_Pic_Coordinate_Temp_Y ]
ret
PageAd_Pic_Coordinate_Return_Call:
call PageAd_Pic_Coordinate_Return
'EndBlock
'EndBlock
'EndBlock

'//=================��������=====================//
PageAd_CalTouch:
'Block
endasm

Dim shared PageAd_CalTouch_CurVal
'PageAd_Sys_Over


if G_touch_x > 8 and G_touch_X < 80 then

	'���������
	if G_touch_y > 10 and G_touch_y < 50 then
		'ȷ��������ѭ��
		G_touch_ID = 1
		PageAd_CalTouch_CurVal = G_touch_x - 50 '- 15 - 30
		'ѡ��ͨ��
		if G_touch_x < 20  then
			PageAd_Show_Passage = ( G_touch_y - 10 ) / 10
		
		'��ɫֵ L
		else if G_touch_y < 20 then
		PageAd_Mix_Light = PageAd_CalTouch_CurVal
		'R
		else if G_touch_y < 30 then
		PageAd_Mix_Red = PageAd_CalTouch_CurVal
		'G
		else if G_touch_y < 40 then
		PageAd_Mix_Green = PageAd_CalTouch_CurVal
		'B
		else if G_touch_y < 50 then
		PageAd_Mix_Blue = PageAd_CalTouch_CurVal
		end if
		
	else if G_touch_y < 112 and G_touch_y > 52 then
		G_touch_ID = ( ( G_touch_y - 52 ) / 20 ) * 3 + ( G_touch_x - 3 ) / 24
		'����ת��Բ˵����д���
		asm
		ld int r1, [ vint_G_touch_ID ]
		cal int mul r1, 4
		cal int add r1, PageAd_Menu_Jump_Table
		call [ r1 ]
		endasm
	end if

end if

asm
ret
'EndBlock
'//==========�Բ˵��Ĵ���==========//
'Block
PageAd_Menu_0:
ld int r1, 1
cal int sub r1, [ vint_PageAd_Show_TB ]
ld int [ vint_PageAd_Show_TB ], r1
ret

PageAd_Menu_1:
ld int r1, 1
cal int sub r1, [ vint_PageAd_Show_LR ]
ld int [ vint_PageAd_Show_LR ], r1
ret

PageAd_Menu_2:
ld int r1, 1
cal int sub r1, [ vint_PageAd_Show_Gray ]
ld int [ vint_PageAd_Show_Gray ], r1
ret

PageAd_Menu_3:
ld int [ vint_PageAd_Show_Scan_Type ], 1
ld int [ vint_PageAd_Main_Max_X ], 120
ld int [ vint_PageAd_Main_Max_Y ], 320
ret

PageAd_Menu_4:
ld int [ vint_PageAd_Show_Scan_Type ], 2
ld int [ vint_PageAd_Main_Max_X ], 320
ld int [ vint_PageAd_Main_Max_Y ], 160
ret

PageAd_Menu_5:
ld int [ vint_PageAd_Show_Scan_Type ], 3
ld int [ vint_PageAd_Main_Max_X ], 240
ld int [ vint_PageAd_Main_Max_Y ], 320
ret
'/ȷ��
PageAd_Menu_6:
'���Ĵ���ҳ��
ld int [ PageAd_Pixel_Param_hPage ], [ vint_PageAd_Page_Src ]
'���Ĵ���ҳ��Ĵ�С
ld int [ vint_PageAd_Show_Scan_Type ], 3
ld int [ vint_PageAd_Main_Max_X ], 240
ld int [ vint_PageAd_Main_Max_Y ], 320
'�˳�
ld int [ vint_PageAd_Sys_Over ], 1
ret

'/ȡ��
PageAd_Menu_7:

ld int [ vint_PageAd_Sys_Over ], 1
ret

'/ֱ�ӷ��ص�ǰЧ��ҳ��
PageAd_Menu_8:
'����ҳ��
ld int r2, [ vint_PageAd_Page_Src ]
ld int r3, [ vint_PageAd_Page_Buff_Catch ]
OUT 22,0
'�˳�
ld int [ vint_PageAd_Sys_Over ], 1
ret
'EndBlock
PageAd_QingWuShiWo:
endasm
'EndBlock

'EndBlock







