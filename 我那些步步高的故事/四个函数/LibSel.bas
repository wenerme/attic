setlcd( 240, 320)
'�����getLibCount���ļ���id�� ���Ը��ĵ�
const getLibCount_ID = 9


declare function LibSel( Lib_Name$)
'������������LibSel���б����
declare function getLibCount( LibName$)
declare function getInput()

'//��ȡLib��ͼƬ������
function getLibCount( LibName$)
'Block

dim shared getLibCount_name$, getLibCount_re

getLibCount_name$ = LibName$

open getLibCount_name$ for binary as #getLibCount_ID

get #getLibCount_ID, getLibCount_re

getLibCount = getLibCount_re

end function

'EndBlock
'//��ȡ������Ϣ
function getInput()
'Block
'//����
'��ֵ����
Dim shared G_key_x, G_key_y
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


'//=========LibSel==========//
'//=========LibͼƬѡ����==========//
'���� Wener
'��̳Id a3160586 (club.eebbk.com   �����)
'QQ 514403150
'//LibͼƬѡ����
function LibSel( Lib_Name$)
'Block
	Dim shared LibSel_CurSelected	'��һ��ѡ�е�id  һ��ҳ����һ�����ĸ�ͼ��Ҳ�����ĸ�id�� 1 2 3 4
	Dim shared LibSel_CurMove, LibSel_CurSelected_Temp
	Dim shared LibSel_CurBG_PicID, LibSel_CurBG_Pic, LibSel_LastBG_Pic
	Dim shared LibSel_Animate_Run	
	Dim shared LibSel_Animate_STEP

	Dim shared LibSel_LibPicCount
	Dim shared LibSel_PicOffsetCount	'�����count/2 �������㵱ǰѡ��ͼƬ��id
	Dim shared LibSel_cur_PicOffset
	'ҳ����
	Dim shared LibSel_Buff_Page, LibSel_Bg_Page, LibSel_Scal_Page
	'ͼƬ���
	Dim shared LibSel_Selected_Pic, LibSel_CurSelected_Pic
	'ui��ͼƬ�����һЩ��Ϣ
	Dim shared LibSel_ui_Title, LibSel_ui_menu, LibSel_ui_menu_Pr, LibSel_ui_scroll
	Dim shared LibSel_ui_scroll_preWid, LibSel_ui_scroll_Max_X
	Dim shared LibSel_ui_scroll_curOffset '���ƹ�������ƫ��λ��
	Dim shared LibSel_ui_scroll_PreMove	'ÿ���ƶ��ĳ���

	Dim shared LibSel_PicX, LibSel_PicY
	'һЩ��Ϣ
	Dim shared LibSel_Pic_ID, LibSel_Pic_Handle
	Dim shared LibSel_Pos_ID
	Dim shared LibSel_Res_Name$, LibSel_Lib_Name$

	Dim shared LibSel_i, LibSel_j, LibSel_increase, LibSel_Temp
	Dim shared LibSel_QuitState, LibSel_Main_Rs_Temp
	dim shared SYS_Fe$ '���������Ҫȫ�ֻ�
	
	LibSel_Lib_Name$ =  Lib_Name$
	asm
		call LibSel_Satrt_Lable
		LibSel_End_Lable:

		'����ֵ
		ld int [ rb ], [ vint_LibSel_CurBG_Pic ]
	endasm

end function
'LibSel��������
'Block
vasm(" jmp LibSel_QINGWUSHIWODECUNZAI:")


'//��ʼ��
'/�����ļ���
asm
LibSel_Satrt_Lable:
endasm

LibSel_CurSelected = 1
LibSel_Res_Name$ = "LibSel" + SYS_Fe$

LibSel_Buff_Page = createpage()
LibSel_Bg_Page 	 = createpage()
LibSel_Scal_Page = createpage()

LibSel_Selected_Pic 	= loadres( LibSel_Res_Name$, 1)
LibSel_CurSelected_Pic 	= loadres( LibSel_Res_Name$, 2)
'/����uiͼƬ
LibSel_ui_Title 	= loadres( LibSel_Res_Name$, 3)
LibSel_ui_menu 		= loadres( LibSel_Res_Name$, 4)
LibSel_ui_menu_Pr 	= loadres( LibSel_Res_Name$, 5)
LibSel_ui_scroll 	= loadres( LibSel_Res_Name$, 6)

LibSel_LibPicCount 		= getLibCount( LibSel_Lib_Name$)
LibSel_LibPicCount 		= LibSel_LibPicCount - ( LibSel_LibPicCount mod 2 )
LibSel_PicOffsetCount 	= LibSel_LibPicCount / 2 '��ʱ����ͼƬΪ������
LibSel_ui_scroll_preWid = 200 / LibSel_LibPicCount
'���Լ����Ϳ�ˣ�Ҳ��֪�����ÿ���ƶ��ĳ�������ô��� ���������ǶԵ�
LibSel_ui_scroll_PreMove = LibSel_ui_scroll_preWid
LibSel_ui_scroll_Max_X = LibSel_ui_scroll_PreMove * LibSel_LibPicCount - 1 '������������ 
'LibSel_ui_scroll_PreMove = ( 200 - LibSel_ui_scroll_preWid / 2 ) / LibSel_LibPicCount
LibSel_ui_scroll_curOffset = 0
LibSel_cur_PicOffset = 0

if LibSel_ui_scroll_preWid < 20 then LibSel_ui_scroll_preWid = 20


'//��������
LibSel_Pos_ID = 1
asm
call LibSel_Init_Asm
call LibSel_ScalONE_and_CopyTOScal_Parameter_INIT
endasm
'//ת�����Ե�ѭ��
LibSel_i = 0
while LibSel_i < 6 and LibSel_i < LibSel_LibPicCount

		asm
		call LibSel_ScalONE_and_CopyTOScal

		cal int add [ LibSel_loadres_ID ], 1
		cal int add [ vint_LibSel_Pos_ID ], 1

		endasm
LibSel_i = LibSel_i + 1
wend

'//================================ѡ�����ѭ��===================================//

'Block
LibSel_CurBG_PicID = 1
LibSel_CurBG_Pic = loadres( LibSel_Lib_Name$, LibSel_CurBG_PicID)
LibSel_QuitState = 0

asm
ld int [ vint_G_Func_calTouchId ], LibSel_CalTouchID

out 46, 0
ld int [ vint_G_User_Inkey ], r3
jmp LibSel_TOEscapeTheFirstWaitkey
endasm
while not LibSel_QuitState
LibSel_CurMove = 0

'locate( 1, 1)
'print LibSel_PicOffsetCount; LibSel_cur_PicOffset
G_User_Inkey = waitkey()
asm
LibSel_TOEscapeTheFirstWaitkey:
endasm
getInput()

	if G_key_down then
		LibSel_CurMove = 1
	else if G_key_up then
		LibSel_CurMove = - 1
	else if G_key_left then
		LibSel_CurMove = - 2
	else if G_key_right then
		LibSel_CurMove = 2
	end if

LibSel_CurSelected_Temp =  LibSel_CurSelected + LibSel_CurMove 

	if LibSel_CurSelected_Temp < 1 or LibSel_CurSelected_Temp > 4 then
			
			if LibSel_CurMove > 0 and LibSel_cur_PicOffset < LibSel_PicOffsetCount - 2 then
				LibSel_cur_PicOffset = LibSel_cur_PicOffset + 1
				LibSel_Animate_Run = 1
				asm
				ld int [ vint_LibSel_Show_ScalOnBG_run  ], 1
				ld int [ LibSel_Show_ScalOnBG_Offset_T ], - 1
				
				call LibSel_Selected_BaseAnimate
				call LibSel_Selected_Animate
				endasm
				
				freeres( LibSel_LastBG_Pic )
				
				'��Ҫ��Scalҳ�洦�� �� 1 2 λ�õ��Ƴ�ȥ
				STRETCHBLTPAGEEX( 0, 0, 160, 220, 80, 0, LibSel_Scal_Page, LibSel_Scal_Page)
				'�����µ�����ͼ
				if LibSel_cur_PicOffset < = LibSel_PicOffsetCount - 3 then
				asm
				call LibSel_ScalONE_and_CopyTOScal_Parameter_INIT
				
				ld int r1, [ vint_LibSel_cur_PicOffset ]
				cal int add r1, 3
				cal int mul r1, 2
				ld int [ vint_LibSel_Temp ], r1
				ld int [ LibSel_loadres_ID ], r1
				ld int [ vint_LibSel_Pos_ID ], 6
				call LibSel_ScalONE_and_CopyTOScal
				
				cal int add [ vint_LibSel_Temp ], - 1
				ld int [ LibSel_loadres_ID ], [ vint_LibSel_Temp ]
				ld int [ vint_LibSel_Pos_ID ], 5
				call LibSel_ScalONE_and_CopyTOScal	
				endasm
				end if
				'flippage( LibSel_Scal_Page)
				'waitkey()
			else if LibSel_CurMove < 0 and LibSel_cur_PicOffset > 0 then
				LibSel_cur_PicOffset = LibSel_cur_PicOffset - 1
				LibSel_Animate_Run = 1
				'��Ҫ��Scalҳ�洦�� �� 56 λ�õ��Ƴ�ȥ
				STRETCHBLTPAGEEX( 80, 0, 160, 220, 0, 0, LibSel_Scal_Page, LibSel_Scal_Page)
				'�����µ�����ͼ
				asm
				call LibSel_ScalONE_and_CopyTOScal_Parameter_INIT
				
				ld int r1, [ vint_LibSel_cur_PicOffset ]
				cal int add r1, 1
				cal int mul r1, 2
				ld int [ vint_LibSel_Temp ], r1
				ld int [ LibSel_loadres_ID ], r1
				ld int [ vint_LibSel_Pos_ID ], 2
				call LibSel_ScalONE_and_CopyTOScal
				
				cal int add [ vint_LibSel_Temp ], - 1
				ld int [ LibSel_loadres_ID ], [ vint_LibSel_Temp ]
				ld int [ vint_LibSel_Pos_ID ], 1
				call LibSel_ScalONE_and_CopyTOScal	
				endasm
				'flippage( LibSel_Scal_Page)
				'waitkey()				
				asm
				ld int [ vint_LibSel_Show_ScalOnBG_run  ], 1
				ld int [ LibSel_Show_ScalOnBG_Offset_T ], 1
				
				call LibSel_Selected_BaseAnimate
				call LibSel_Selected_Animate
				endasm
			
				freeres( LibSel_LastBG_Pic )
				

				
			end if
			
			
			LibSel_CurMove = 0
			
	else if LibSel_CurMove then
		LibSel_CurSelected = LibSel_CurSelected_Temp
		
			asm
				call LibSel_Selected_BaseAnimate
				call LibSel_Selected_Animate
			endasm
			freeres( LibSel_LastBG_Pic )
		
		
	end if

asm

'��ӱ���ɫ
ld int [ LibSel_FILLPAGE_Paramater_1 ], [ vint_LibSel_BG_Page ]
ld int r3, LibSel_FILLPAGE_Paramater
out 23, 0

'showpic( LibSel_BG_Page, LibSel_CurBG_Pic, 0, 0, 240, 320, 0, 0, 1)
ld int [ LibSel_ShowPic_Paramater_1 ], [ vint_LibSel_BG_Page ]
ld int [ LibSel_ShowPic_Paramater_2 ], [ vint_LibSel_CurBG_Pic ]

ld int [ LibSel_ShowPic_Paramater_5 ], 240
ld int [ LibSel_ShowPic_Paramater_6 ], 320
ld int [ LibSel_ShowPic_Paramater_7 ], 0
ld int [ LibSel_ShowPic_Paramater_8 ], 0
'ͼƬ����
call LibSel_Center_Pic:
ld int r3, LibSel_ShowPic_Paramater
out 20, 0
endasm

'����
asm


'//����UI
call LibSel_UI_Constructor
'//��ʾѡ��ͼ
call LibSel_Show_ScalOnBG_NOSlide
endasm
flippage( LibSel_BG_Page )
'msdelay( 50)
asm
ld int r3, 35
out 27, 0
endasm
wend
'EndBlock

'�ͷ���Դ
deletepage( LibSel_Buff_Page)
deletepage( LibSel_Bg_Page 	)
deletepage( LibSel_Scal_Page)

freeres( LibSel_Selected_Pic)
freeres( LibSel_CurSelected_Pic )

freeres( LibSel_ui_Title 	)
freeres( LibSel_ui_menu 	)
freeres( LibSel_ui_menu_Pr 	)
freeres( LibSel_ui_scroll 	)

asm
'����

ret
endasm


'//////////////��ಿ��

asm
;//===========Init===========//
LibSel_Init_Asm:
'Block
;'Ϊ�˾������������� ֱ���ò���� ɵ��ʽ������
;'/Buffҳ
ld int [ LibSel_ID2CD_Jump_1 ], LibSel_ID2CD_1
ld int [ LibSel_ID2CD_Jump_2 ], LibSel_ID2CD_2
ld int [ LibSel_ID2CD_Jump_3 ], LibSel_ID2CD_3
ld int [ LibSel_ID2CD_Jump_4 ], LibSel_ID2CD_4
ld int [ LibSel_ID2CD_Jump_5 ], LibSel_ID2CD_5
ld int [ LibSel_ID2CD_Jump_6 ], LibSel_ID2CD_6

;'/BGҳ
ld int [ LibSel_ID2CD_BG_Jump_1 ], LibSel_ID2CD_BG_1
ld int [ LibSel_ID2CD_BG_Jump_2 ], LibSel_ID2CD_BG_2
ld int [ LibSel_ID2CD_BG_Jump_3 ], LibSel_ID2CD_BG_3
ld int [ LibSel_ID2CD_BG_Jump_4 ], LibSel_ID2CD_BG_4

;'/��ʼ���Ա���ɫ��֧�� ��ɫͳһΪ 0x0e62a1 10576398

ld int [ LibSel_FILLPAGE_Paramater_2 ], 0
ld int [ LibSel_FILLPAGE_Paramater_3 ], 0
ld int [ LibSel_FILLPAGE_Paramater_4 ], 240
ld int [ LibSel_FILLPAGE_Paramater_5 ], 320
ld int [ LibSel_FILLPAGE_Paramater_6 ], 10576398

ret
'EndBlock
'//�����б�
'Block
'Ϊ����ӱ���ɫ
'OUT 23,0 fillpage�Ķ˿�
LibSel_FILLPAGE_Paramater:
LibSel_FILLPAGE_Paramater_6:
.block 4 0
LibSel_FILLPAGE_Paramater_5:
.block 4 0
LibSel_FILLPAGE_Paramater_4:
.block 4 0
LibSel_FILLPAGE_Paramater_3:
.block 4 0
LibSel_FILLPAGE_Paramater_2:
.block 4 0
LibSel_FILLPAGE_Paramater_1:
.block 4 0

'/Ϊ�˼��ٲ������ĵĴ���  �Ͷ�������Щ�����б� ��Ϊ�⼸����������һ����õ�
'/showpic SHOWPIC(PAGE,PIC,DX,DY,W,H,X,Y,MODE)
LibSel_showpic_Paramater:
LibSel_showpic_Paramater_9:
data LibSel_showpic_mode dword 1 '��Ϊ������˵ģʽ����1

LibSel_showpic_Paramater_8:
LibSel_showpic_SrcY:
.block 4 0
LibSel_showpic_Paramater_7:
LibSel_showpic_SrcX:
.block 4 0
LibSel_showpic_Paramater_6:
LibSel_showpic_Hgt:
.block 4 0
LibSel_showpic_Paramater_5:
LibSel_showpic_Wid:
.block 4 0
LibSel_showpic_Paramater_4:
LibSel_showpic_DesY:
.block 4 0
LibSel_showpic_Paramater_3:
LibSel_showpic_Desx:
.block 4 0
LibSel_showpic_Paramater_2:
LibSel_showpic_Pic:
.block 4 0
LibSel_showpic_Paramater_1:
LibSel_showpic_Page:
.block 4 0

'/STRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)
LibSel_STRETCHBLTPAGEEX_Paramater:

LibSel_STRETCHBLTPAGEEX_Paramater_8:
 LibSel_STRETCHBLTPAGEEX_SrcPage:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_7:
 LibSel_STRETCHBLTPAGEEX_DesPage:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_6:
 LibSel_STRETCHBLTPAGEEX_SrcY:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_5:
 LibSel_STRETCHBLTPAGEEX_Srcx:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_4:
 LibSel_STRETCHBLTPAGEEX_Hgt:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_3:
 LibSel_STRETCHBLTPAGEEX_Wid:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_2:
 LibSel_STRETCHBLTPAGEEX_DesY:
.block 4 0
LibSel_STRETCHBLTPAGEEX_Paramater_1:
 LibSel_STRETCHBLTPAGEEX_Desx:
.block 4 0

'/loadres name$ id
LibSel_loadres_Paramater:
LibSel_loadres_Paramater_2:
 LibSel_loadres_ID:
.block 4 0
LibSel_loadres_Paramater_1:
 LibSel_loadres_Name:
.block 4 0

'//
LibSel_ID2CD_Jump_Table:
LibSel_ID2CD_Jump_1:
.block 4 0
LibSel_ID2CD_Jump_2:
.block 4 0
LibSel_ID2CD_Jump_3:
.block 4 0
LibSel_ID2CD_Jump_4:
.block 4 0
LibSel_ID2CD_Jump_5:
.block 4 0
LibSel_ID2CD_Jump_6:
.block 4 0

LibSel_ID2CD_1:
ld int r1, 0
ld int r2, 0
ret

LibSel_ID2CD_2:
ld int r1, 0
ld int r2, 107
ret

LibSel_ID2CD_3:
ld int r1, 80
ld int r2, 0
ret

LibSel_ID2CD_4:
ld int r1, 80
ld int r2, 107
ret

LibSel_ID2CD_5:
ld int r1, 160
ld int r2, 0
ret

LibSel_ID2CD_6:
ld int r1, 160
ld int r2, 107
ret

'//BG ���������ͼ��λ�� ��ʾѡ����ʱ��Ҫ - 2
LibSel_ID2CD_BG_Jump_Table:
LibSel_ID2CD_BG_Jump_1:
.block 4 0
LibSel_ID2CD_BG_Jump_2:
.block 4 0
LibSel_ID2CD_BG_Jump_3:
.block 4 0
LibSel_ID2CD_BG_Jump_4:
.block 4 0

LibSel_ID2CD_BG_1:
ld int r1, 20
ld int r2, 34
ret

LibSel_ID2CD_BG_2:
ld int r1, 20
ld int r2, 155
ret

LibSel_ID2CD_BG_3:
ld int r1, 140
ld int r2, 34
ret

LibSel_ID2CD_BG_4:
ld int r1, 140
ld int r2, 155
ret
'EndBlock
;//=================Idת����--BUFFҳ����==================//
LibSel_ID2CD:
'Block
;����Сҳ���id����  �������ʾ��buffҳ����ֻ�� 1234 id
;���� r3 ���� r1, r2
'//idת����
'/����
'
' 1 3 5
' 2 4 6
'
cal int add r3, - 1
cal int mul r3, 4
cal int add r3, LibSel_ID2CD_Jump_Table

call [ r3 ]

ret
'EndBlock
;//=================Idת����--BGҳ����==================//
LibSel_ID2CD_BG:
'Block
;����Сҳ���id����
;���� r3 ���� r1, r2
'//idת����
'/����
'
' 1 3
' 2 4 
'
cal int add r3, - 1
cal int mul r3, 4
cal int add r3, LibSel_ID2CD_BG_Jump_Table

call [ r3 ]

ret
'EndBlock
;//===================����Сͼ====================//
PageScal_Process:
;���� r1 ��Դҳ�� r2 ���ҳ��
'Block

ld int [ PageScal_Process_ReadPixel_Page ], r1
ld int [ PageScal_Process_Pixel_Page ], r2

ld int [ PageScal_Process_x ], 0
ld int [ PageScal_Process_y ], 0

ld int [ PageScal_Process_srcy ], 0

PageScal_Process_Y_Bend:
;'while < 320
cmp int [ PageScal_Process_srcy ], 320
jpc AE PageScal_Process_Y_Wend:
	
	;'=0
	ld int [ PageScal_Process_srcx ], 0
	ld int [ PageScal_Process_x ], 0
	;'while < 240
	PageScal_Process_X_Bend:
	cmp int [ PageScal_Process_srcx ], 240
	jpc AE PageScal_Process_X_Wend:
	
	;'readpixel
	LD int r3, PageScal_Process_ReadPixel_Param_3
	OUT 25,0
	
	LD int [ PageScal_Process_color ],r3
	
	;'pixel
	LD int r3, PageScal_Process_Pixel_Param_4	
	OUT 24,0
	
	;'+
	cal int add [ PageScal_Process_srcx ], 3
	;'+1
	cal int add [ PageScal_Process_x ], 1
	;'wend
	jmp PageScal_Process_X_Bend:
	PageScal_Process_X_Wend:
;'+
cal int add [ PageScal_Process_srcy ], 3
;'+1
cal int add [ PageScal_Process_y ], 1
;'wend
jmp PageScal_Process_Y_Bend:
PageScal_Process_Y_Wend:

ret

;'//==����Щ


PageScal_Process_srcy:
PageScal_Process_ReadPixel_Param_3:
.block 4 0
PageScal_Process_srcx:
PageScal_Process_ReadPixel_Param_2:
.block 4 0
PageScal_Process_ReadPixel_Page:
PageScal_Process_ReadPixel_Param_1:
.block 4 0

PageScal_Process_color:
PageScal_Process_Pixel_Param_4:
.block 4 0
PageScal_Process_y:
PageScal_Process_Pixel_Param_3:
.block 4 0
PageScal_Process_x:
PageScal_Process_Pixel_Param_2:
.block 4 0
PageScal_Process_Pixel_Page:
PageScal_Process_Pixel_Param_1:
.block 4 0
'EndBlock

;//=================���ſ����Ĳ�����ʼ
LibSel_ScalONE_and_CopyTOScal_Parameter_INIT:
'Block

ld int [ LibSel_loadres_Name ], [ vstr_LibSel_Lib_Name ]
ld int [ LibSel_loadres_ID ], 1


ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_3 ], 80
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_4 ], 107

ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_5 ], 0
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_6 ], 0
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_7 ], [ vint_LibSel_Scal_Page ]
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_8 ], [ vint_LibSel_Buff_Page ]


ld int [ LibSel_showpic_SrcX ], 0
ld int [ LibSel_showpic_SrcY ], 0
ld int [ LibSel_showpic_DesX ], 0
ld int [ LibSel_showpic_DesY ], 0
ld int [ LibSel_showpic_Wid ], 240
ld int [ LibSel_showpic_hgt ], 320
ld int [ LibSel_showpic_Page ], [ vint_LibSel_Buff_Page ]

ret
'EndBlock
;//=================����һ��ͼ��������Scalҳ��Ĺ���====================//
LibSel_ScalONE_and_CopyTOScal:
'���� 
'LibSel_loadres_ID ����ͼƬ��ID
'vint_LibSel_Pos_ID	ͼƬλ�� 1 - 6
'Block

'��ӱ���ɫ
ld int [ LibSel_FILLPAGE_Paramater_1 ], [ vint_LibSel_Buff_Page ]
ld int r3, LibSel_FILLPAGE_Paramater
out 23, 0

;'/loadres 1
ld int r3, [ LibSel_loadres_Name ]
ld int r2, [ LibSel_loadres_ID ]
out 19, 0
ld int [ vint_LibSel_Pic_Handle ], r3
'/showpic

ld int [ LibSel_showpic_Pic ], r3
'ʹͼƬ������
call LibSel_Center_Pic
ld int r3, LibSel_showpic_Paramater
out 20, 0
'/����
ld int r1, [ vint_LibSel_Buff_Page ]
ld int r2, [ vint_LibSel_Buff_Page ]
call PageScal_Process:

'/����λ��
ld int r3, [ vint_LibSel_Pos_ID ]
call LibSel_ID2CD

'/STRETCHBLTPAGEEX( ?, ?, 80, 107, 0, 0, re, buff)
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_1 ], r1
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_2 ], r2

ld int r3, LibSel_STRETCHBLTPAGEEX_Paramater
OUT 80,0

'/freeres
ld int r3, [ vint_LibSel_Pic_Handle ]
OUT 26,0

ret
'EndBlock

data LibSel_Show_FlyOut_Transfer_X_Offset dword 0
data LibSel_Show_FlyOut_Transfer_Y_Offset dword 0
data LibSel_Show_FlyOut_Transfer_SrcID  dword 0
data LibSel_Show_FlyOut_Transfer_DesID  dword 0

data LibSel_Show_FlyOut_Transfer_ToWord  dword 0	'����1Ϊ��£  -1Ϊ�ɳ�
DATA LibSel_Show_FlyOut_Transfer_ToWord_RELATE dword 0 	'Ϊ��ʹ���������
;//========================����ͼ�ķɳ���Ч============================//
LibSel_Show_FlyOut_Transfer:

'Block

cmp int [ LibSel_Show_FlyOut_Transfer_ToWord ], - 1
jpc z LibSel_Show_FlyOut_Transfer_ToWord_FlyOyt:

	ld int [ LibSel_Show_FlyOut_Transfer_ToWord_RELATE ], 120
	'120 - y
	cal int sub [ LibSel_Show_FlyOut_Transfer_ToWord_RELATE ], [ LibSel_Show_FlyOut_Transfer_Y_Offset ]
	ld int [ LibSel_Show_FlyOut_Transfer_Y_Offset ], [ LibSel_Show_FlyOut_Transfer_ToWord_RELATE ]

	ld int [ LibSel_Show_FlyOut_Transfer_ToWord_RELATE ], 120
	'120 - x
	cal int sub [ LibSel_Show_FlyOut_Transfer_ToWord_RELATE ], [ LibSel_Show_FlyOut_Transfer_X_Offset ]
	ld int [ LibSel_Show_FlyOut_Transfer_X_Offset ], [ LibSel_Show_FlyOut_Transfer_ToWord_RELATE ]

LibSel_Show_FlyOut_Transfer_ToWord_FlyOyt:

call LibSel_Show_FlyOut_Transfer_AND_ScalOnBG_Parameter_INIT:


cal int mul [ LibSel_Show_FlyOut_Transfer_Y_Offset ], - 1
cal int mul [ LibSel_Show_FlyOut_Transfer_X_Offset ], - 1

ld int [ LibSel_Show_FlyOut_Transfer_SrcID ], 1
ld int [ LibSel_Show_FlyOut_Transfer_DesID ], 1
call LibSel_Show_FlyOut_Transfer_Process

cal int mul [ LibSel_Show_FlyOut_Transfer_Y_Offset ], -1

ld int [ LibSel_Show_FlyOut_Transfer_SrcID ], 2
ld int [ LibSel_Show_FlyOut_Transfer_DesID ], 2
call LibSel_Show_FlyOut_Transfer_Process

cal int mul [ LibSel_Show_FlyOut_Transfer_Y_Offset ], -1
cal int mul [ LibSel_Show_FlyOut_Transfer_X_Offset ], -1

ld int [ LibSel_Show_FlyOut_Transfer_SrcID ], 3
ld int [ LibSel_Show_FlyOut_Transfer_DesID ], 3
call LibSel_Show_FlyOut_Transfer_Process

cal int mul [ LibSel_Show_FlyOut_Transfer_Y_Offset ], -1

ld int [ LibSel_Show_FlyOut_Transfer_SrcID ], 4
ld int [ LibSel_Show_FlyOut_Transfer_DesID ], 4
call LibSel_Show_FlyOut_Transfer_Process

ret

;'//�ɳ��ļ��� ��Ҫ��ƫ�ƺ� LibSel_Show_ScalOnBG_Process: ���̲�ͬ
'/�����빫��һ���� ��������
LibSel_Show_FlyOut_Transfer_Process:

;'/Ŀ��λ��
ld int r3, [ LibSel_Show_FlyOut_Transfer_DesID ]
call LibSel_ID2CD_BG

cal int add r1, [ LibSel_Show_FlyOut_Transfer_X_Offset ]'����ƫ��
cal int add r2, [ LibSel_Show_FlyOut_Transfer_Y_Offset ]

ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_1 ], r1
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_2 ], r2



;'/Դλ��
ld int r3, [ LibSel_Show_FlyOut_Transfer_SrcID ]
call LibSel_ID2CD

ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_5 ], r1
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_6 ], r2

ld int r3, LibSel_STRETCHBLTPAGEEX_Paramater
out 80, 0

'/�����ͼƬ
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_Selected_Pic ]

ld int [ LibSel_Showpic_Desx ], [ LibSel_STRETCHBLTPAGEEX_Paramater_1 ]
ld int [ LibSel_Showpic_DesY ], [ LibSel_STRETCHBLTPAGEEX_Paramater_2 ]
cal int add [ LibSel_Showpic_DesY ], - 2
ld int r3, LibSel_showpic_Paramater

out 20, 0

ret
'EndBlock

'//=========�������̵Ĳ�����ʼ=========//
LibSel_Show_FlyOut_Transfer_AND_ScalOnBG_Parameter_INIT:
'Block
;'/
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_3 ], 80
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_4 ], 107
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_7 ], [ vint_LibSel_BG_Page ]
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_8 ], [ vint_LibSel_Scal_Page ]

ld int [ LibSel_Showpic_Paramater_1 ], [ vint_LibSel_BG_Page ]

ld int [ LibSel_Showpic_Paramater_5 ], 80
ld int [ LibSel_Showpic_Paramater_6 ], 110
ld int [ LibSel_Showpic_Paramater_7 ], 0
ld int [ LibSel_Showpic_Paramater_8 ], 0
ret
'EndBlock

;//========================��ʾ���Ժ�ѡ��ͼƬ��BG-----������������ͨ��============================//
LibSel_Show_ScalOnBG_NOSlide:
'Block

call LibSel_Show_FlyOut_Transfer_AND_ScalOnBG_Parameter_INIT:
'/�൱���Ǹ� 4��ѭ��
'/����������⼸��ѭ���в���
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_Selected_Pic ]

ld int [ LibSel_Show_ScalOnBG_SrcID ], 1
ld int [ LibSel_Show_ScalOnBG_DesID ], 1
call LibSel_Show_ScalOnBG_Process

ld int [ LibSel_Show_ScalOnBG_SrcID ], 2
ld int [ LibSel_Show_ScalOnBG_DesID ], 2
call LibSel_Show_ScalOnBG_Process

ld int [ LibSel_Show_ScalOnBG_SrcID ], 3
ld int [ LibSel_Show_ScalOnBG_DesID ], 3
call LibSel_Show_ScalOnBG_Process

ld int [ LibSel_Show_ScalOnBG_SrcID ], 4
ld int [ LibSel_Show_ScalOnBG_DesID ], 4
call LibSel_Show_ScalOnBG_Process

'/����ѡ�е�ͼƬ
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_CurSelected_Pic ]

ld int r3, [ vint_LibSel_CurSelected ]
call LibSel_ID2CD_BG

cal int add r2, - 2

ld int [ LibSel_Showpic_Desx ], r1
ld int [ LibSel_Showpic_DesY ], r2

ld int r3, LibSel_showpic_Paramater
out 20, 0

ret
'EndBlock
data LibSel_Show_ScalOnBG_Offset dword 0
data LibSel_Show_ScalOnBG_SrcID  dword 0
data LibSel_Show_ScalOnBG_DesID  dword 0
data LibSel_Show_ScalOnBG_Offset_T dword 0	'���� �����Ϊ - 1 ��Ϊ 1

data LibSel_Show_ScalOnBG_Slide_ID_Offset  dword 0	'��ͬ�Ļ���������ͬ ��0 ��2
;//========================��ʾ���Ժ�ѡ��ͼƬ��BG============================//
LibSel_Show_ScalOnBG:
'Block
'�������������ķ������� [ LibSel_Show_ScalOnBG_Offset_T ] ��ϵ����
cal int mul [ LibSel_Show_ScalOnBG_Offset ], [ LibSel_Show_ScalOnBG_Offset_T ]

ld int [ LibSel_Show_ScalOnBG_Slide_ID_Offset ], [ LibSel_Show_ScalOnBG_Offset_T ]
cal int add [ LibSel_Show_ScalOnBG_Slide_ID_Offset ], 1

call LibSel_Show_FlyOut_Transfer_AND_ScalOnBG_Parameter_INIT:
'/�൱���Ǹ� 4��ѭ��
'/����������⼸��ѭ���в���
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_Selected_Pic ]

ld int [ LibSel_Show_ScalOnBG_SrcID ], 1
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
ld int [ LibSel_Show_ScalOnBG_DesID ], 1
call LibSel_Show_ScalOnBG_Process

ld int [ LibSel_Show_ScalOnBG_SrcID ], 2
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
ld int [ LibSel_Show_ScalOnBG_DesID ], 2
call LibSel_Show_ScalOnBG_Process

ld int [ LibSel_Show_ScalOnBG_SrcID ], 3
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
ld int [ LibSel_Show_ScalOnBG_DesID ], 3
call LibSel_Show_ScalOnBG_Process

ld int [ LibSel_Show_ScalOnBG_SrcID ], 4
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
ld int [ LibSel_Show_ScalOnBG_DesID ], 4
call LibSel_Show_ScalOnBG_Process

'/�����Ƕ������ �������ƺ��ڲ�ͬ�������Ҫ��ͬ����
'/ƫ�Ʊ��෴
ld int r1, [ LibSel_Show_ScalOnBG_Offset_T ]
cal int mul r1, - 120
cal int add [ LibSel_Show_ScalOnBG_Offset ], r1

cal int mul [ LibSel_Show_ScalOnBG_Slide_ID_Offset ], - 1

'//������ԴidӦ����1 2�� ���Ծͼ���2��
ld int [ LibSel_Show_ScalOnBG_SrcID ], 5
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]

ld int [ LibSel_Show_ScalOnBG_DesID ], 3
cal int add [ LibSel_Show_ScalOnBG_DesID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
call LibSel_Show_ScalOnBG_Process


ld int [ LibSel_Show_ScalOnBG_SrcID ], 6
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
cal int add [ LibSel_Show_ScalOnBG_SrcID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]

ld int [ LibSel_Show_ScalOnBG_DesID ], 4
cal int add [ LibSel_Show_ScalOnBG_DesID ], [ LibSel_Show_ScalOnBG_Slide_ID_Offset ]
call LibSel_Show_ScalOnBG_Process


'/����ѡ�е�ͼƬ
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_CurSelected_Pic ]

ld int r3, [ vint_LibSel_CurSelected ]
call LibSel_ID2CD_BG

;'cal int add [ LibSel_Show_ScalOnBG_Offset ], - 120
;'cal int add r1, [ LibSel_Show_ScalOnBG_Offset ] '//ƫ��
cal int add r2, - 2

ld int [ LibSel_Showpic_Desx ], r1
ld int [ LibSel_Showpic_DesY ], r2

ld int r3, LibSel_showpic_Paramater
out 20, 0

ret

;'//����һ�εĹ��� ��Ҫ����λ��id
LibSel_Show_ScalOnBG_Process:
'Block
;'/Ŀ��λ��
ld int r3, [ LibSel_Show_ScalOnBG_DesID ]
call LibSel_ID2CD_BG

cal int add r1, [ LibSel_Show_ScalOnBG_Offset ]'����ƫ��

ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_1 ], r1
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_2 ], r2



;'/Դλ��
ld int r3, [ LibSel_Show_ScalOnBG_SrcID ]
call LibSel_ID2CD

ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_5 ], r1
ld int [ LibSel_STRETCHBLTPAGEEX_Paramater_6 ], r2

ld int r3, LibSel_STRETCHBLTPAGEEX_Paramater
out 80, 0

'/�����ͼƬ


ld int [ LibSel_Showpic_Desx ], [ LibSel_STRETCHBLTPAGEEX_Paramater_1 ]
ld int [ LibSel_Showpic_DesY ], [ LibSel_STRETCHBLTPAGEEX_Paramater_2 ]
cal int add [ LibSel_Showpic_DesY ], - 2
ld int r3, LibSel_showpic_Paramater

out 20, 0

ret
'EndBlock
'EndBlock

;//========================����UI--��ͨ��============================//
LibSel_UI_Constructor_NOSlide:
'Block



ld int [ LibSel_Showpic_Paramater_1 ], [ vint_LibSel_BG_Page ]
ld int [ LibSel_Showpic_Paramater_3 ], 0
ld int [ LibSel_Showpic_Paramater_5 ], 240
ld int [ LibSel_Showpic_Paramater_7 ], 0
ld int [ LibSel_Showpic_Paramater_8 ], 0
ld int [ LibSel_Showpic_Paramater_9 ], 1
'showpic( LibSel_Bg_Page, LibSel_ui_Title, 0, 0, 240, 32, 0, 0, 1)
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_ui_Title ]

ld int [ LibSel_Showpic_Paramater_4 ], 0
ld int [ LibSel_Showpic_Paramater_6 ], 32
ld int r3, LibSel_showpic_Paramater

out 20, 0

'showpic( LibSel_Bg_Page, LibSel_ui_menu, 0, 268, 240, 52, 0, 0, 1)
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_ui_menu ]


ld int [ LibSel_Showpic_Paramater_4 ], 268
ld int [ LibSel_Showpic_Paramater_6 ], 52

out 20, 0

'������ʾ������
'Block
'�������Ǳ䳤�ģ������Ȱ��м䲿�ֻ���һ������ҳ���ϣ�Ȼ��һ���Էŵ�BG��
'�������ĳ��� LibSel_ui_scroll_preWid
ld int [ LibSel_Showpic_Paramater_1 ], [ vint_LibSel_Buff_Page ]
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_ui_scroll ]
ld int [ LibSel_Showpic_Paramater_3 ], 0
ld int [ LibSel_Showpic_Paramater_4 ], 0
ld int [ LibSel_Showpic_Paramater_5 ], 40
ld int [ LibSel_Showpic_Paramater_6 ], 17
ld int [ LibSel_Showpic_Paramater_7 ], 10
ld int r3, LibSel_showpic_Paramater
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0

'��ȡLibSel_ui_scroll_preWid - 20 �ĳ��ȵ�BGҳ��
'STRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)
ld int [ LibSel_UI_Constructor_Temp_rb ], rs
ld int rs, LibSel_STRETCHBLTPAGEEX_Paramater_1
'һֱ����Ld  ���� ��push����
ld int r1, [ vint_LibSel_ui_scroll_curOffset ]
cal int add r1, 30
push r1

push 280
ld int r1, [ vint_LibSel_ui_scroll_preWid ]
cal int add r1, - 20
push r1
push 16
push 0
push 0
push [ vint_LibSel_BG_Page ]
push [ vint_LibSel_Buff_Page ]
'�ָ���ָ��
ld int rs, [ LibSel_UI_Constructor_Temp_rb ]



ld int r3, LibSel_STRETCHBLTPAGEEX_Paramater
out 80, 0

'������ͷ����
'SHOWPIC(PAGE,PIC,DX,DY,W,H,X,Y,MODE)
ld int [ LibSel_UI_Constructor_Temp_rb ], rs
ld int rs, LibSel_ShowPic_Paramater_1

push [ vint_LibSel_BG_Page ]
push [ vint_LibSel_ui_scroll ]
ld int r1, [ vint_LibSel_ui_scroll_curOffset ]
cal int add r1, 20
push r1
push 280
push 10
push 16
push 0
push 0
push 1

'�ָ�ָ��
ld int rs, [ LibSel_UI_Constructor_Temp_rb ]
'���
ld int r3, LibSel_showpic_Paramater
out 20, 0
'�ұ�
cal int add [ LibSel_showpic_Desx ], [ vint_LibSel_ui_scroll_preWid ]
cal int add [ LibSel_showpic_Desx ], - 10
ld int [ LibSel_Showpic_SrcX ], 50
ld int r3, LibSel_showpic_Paramater
out 20, 0
'EndBlock



ret
'EndBlock
' data LibSel_UI_Constructor_Scroll_Offset dword 0
data LibSel_UI_Constructor_Scroll_Mid_Wid dword 0

data LibSel_UI_Constructor_FlyOut_Offset dword 0	'0 - 120��ֵ �����������Ӧ
data LibSel_UI_Constructor_FlyOut_Offset_temp dword 0	'���� �ټ�����
data LibSel_UI_Constructor_FlyOut_Toward dword 0	'����1Ϊ��£  -1Ϊ�ɳ�

data LibSel_UI_Constructor_Temp_rb dword 0
;//========================����UI============================//
LibSel_UI_Constructor:
'Block

cmp int [ LibSel_UI_Constructor_FlyOut_Toward ], 1
jpc nz	LibSel_UI_Constructor_FlyOut_Toward_Out
ld int r1, 120
cal int sub r1, [ LibSel_UI_Constructor_FlyOut_Offset ]
ld int [ LibSel_UI_Constructor_FlyOut_Offset ], r1
LibSel_UI_Constructor_FlyOut_Toward_Out:



'������úܶ� ���Ի������
ld int [ LibSel_Showpic_Paramater_1 ], [ vint_LibSel_BG_Page ]
ld int [ LibSel_Showpic_Paramater_3 ], 0
ld int [ LibSel_Showpic_Paramater_5 ], 240
ld int [ LibSel_Showpic_Paramater_7 ], 0
ld int [ LibSel_Showpic_Paramater_8 ], 0
ld int [ LibSel_Showpic_Paramater_9 ], 1
'showpic( LibSel_Bg_Page, LibSel_ui_Title, 0, 0, 240, 32, 0, 0, 1)
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_ui_Title ]
'//�޸�ƫ��
ld int r1, [ LibSel_UI_Constructor_FlyOut_Offset ]
cal int mul r1, - 32
cal int div r1, 120

ld int [ LibSel_Showpic_Paramater_4 ], r1
ld int [ LibSel_Showpic_Paramater_6 ], 32
ld int r3, LibSel_showpic_Paramater

out 20, 0

'showpic( LibSel_Bg_Page, LibSel_ui_menu, 0, 268, 240, 52, 0, 0, 1)
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_ui_menu ]
'//�޸�ƫ��
ld int r1, [ LibSel_UI_Constructor_FlyOut_Offset ]
cal int mul r1, 52
cal int div r1, 120
ld int [ LibSel_UI_Constructor_FlyOut_Offset_temp ], r1
cal int add r1, 268
ld int [ LibSel_Showpic_Paramater_4 ], r1
ld int [ LibSel_Showpic_Paramater_6 ], 52

out 20, 0

'������ʾ������
'Block
'�������Ǳ䳤�ģ������Ȱ��м䲿�ֻ���һ������ҳ���ϣ�Ȼ��һ���Էŵ�BG��
'�������ĳ��� LibSel_ui_scroll_preWid
ld int [ LibSel_Showpic_Paramater_1 ], [ vint_LibSel_Buff_Page ]
ld int [ LibSel_Showpic_Paramater_2 ], [ vint_LibSel_ui_scroll ]
ld int [ LibSel_Showpic_Paramater_3 ], 0
ld int [ LibSel_Showpic_Paramater_4 ], 0
ld int [ LibSel_Showpic_Paramater_5 ], 40
ld int [ LibSel_Showpic_Paramater_6 ], 17
ld int [ LibSel_Showpic_Paramater_7 ], 10
ld int r3, LibSel_showpic_Paramater
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0
cal int add [ LibSel_Showpic_Paramater_3 ], 40
out 20, 0

'��ȡLibSel_ui_scroll_preWid - 20 �ĳ��ȵ�BGҳ��
'STRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)
ld int [ LibSel_UI_Constructor_Temp_rb ], rs
ld int rs, LibSel_STRETCHBLTPAGEEX_Paramater_1
'һֱ����Ld  ���� ��push����
ld int r1, [ vint_LibSel_ui_scroll_curOffset ]
cal int add r1, 30
push r1
'//�޸�ƫ��
cal int add [ LibSel_UI_Constructor_FlyOut_Offset_temp ], 280
push [ LibSel_UI_Constructor_FlyOut_Offset_temp ]
ld int r1, [ vint_LibSel_ui_scroll_preWid ]
cal int add r1, - 20
push r1
push 16
push 0
push 0
push [ vint_LibSel_BG_Page ]
push [ vint_LibSel_Buff_Page ]
'�ָ���ָ��
ld int rs, [ LibSel_UI_Constructor_Temp_rb ]



ld int r3, LibSel_STRETCHBLTPAGEEX_Paramater
out 80, 0

'������ͷ����
'SHOWPIC(PAGE,PIC,DX,DY,W,H,X,Y,MODE)
ld int [ LibSel_UI_Constructor_Temp_rb ], rs
ld int rs, LibSel_ShowPic_Paramater_1

push [ vint_LibSel_BG_Page ]
push [ vint_LibSel_ui_scroll ]
ld int r1, [ vint_LibSel_ui_scroll_curOffset ]
cal int add r1, 20
push r1
push [ LibSel_UI_Constructor_FlyOut_Offset_temp ]
push 10
push 16
push 0
push 0
push 1

'�ָ�ָ��
ld int rs, [ LibSel_UI_Constructor_Temp_rb ]
'���
ld int r3, LibSel_showpic_Paramater
out 20, 0
'�ұ�
cal int add [ LibSel_showpic_Desx ], [ vint_LibSel_ui_scroll_preWid ]
cal int add [ LibSel_showpic_Desx ], - 10
ld int [ LibSel_Showpic_SrcX ], 50
ld int r3, LibSel_showpic_Paramater
out 20, 0
'EndBlock


ret
'EndBlock

data LibSel_BG_Slide_Left_Pic_ID dword 0
data LibSel_BG_Slide_Right_Pic_ID dword 0
data LibSel_BG_Slide_offset dword 0	'Ϊ0 - 120  �ͺ���������Ӧ��
data LibSel_BG_Slide_toward dword 0	'���� -1�� 1 ��
data LibSel_BG_Slide_toward_relate dword 0	
;'//=====================��������==========================//
LibSel_BG_Slide:
'���� LibSel_BG_Slide_Left_Pic_ID LibSel_BG_Slide_Right_Pic_ID 
'LibSel_BG_Slide_offset LibSel_BG_Slide_toward
'Block
'û���Ż�

cal int mul [ LibSel_BG_Slide_offset ], 2
cal int mul [ LibSel_BG_Slide_offset ], [ LibSel_BG_Slide_toward]

cmp int [ LibSel_BG_Slide_toward ], 1
jpc z LibSel_BG_Slide_toward_LEFT
cal int add [ LibSel_BG_Slide_offset ], 240
LibSel_BG_Slide_toward_LEFT:

'��ӱ���ɫ
ld int [ LibSel_FILLPAGE_Paramater_1 ], [ vint_LibSel_BG_Page ]
ld int r3, LibSel_FILLPAGE_Paramater
out 23, 0

'SHOWPIC(PAGE,PIC,DX,DY,W,H,X,Y,MODE)
ld int [ LibSel_Showpic_Paramater_1 ], [ vint_LibSel_BG_Page ]
ld int [ LibSel_Showpic_Paramater_4 ], 0
ld int [ LibSel_Showpic_Paramater_5 ], 240
ld int [ LibSel_Showpic_Paramater_6 ], 320
ld int [ LibSel_Showpic_Paramater_7 ], 0
ld int [ LibSel_Showpic_Paramater_8 ], 0
ld int [ LibSel_Showpic_Paramater_9 ], 1

ld int [ LibSel_Showpic_Paramater_2 ], [ LibSel_BG_Slide_right_Pic_ID ]
ld int [ LibSel_Showpic_Paramater_3 ], [ LibSel_BG_Slide_offset ]

'ʹͼƬ����
'��ȡ��
ld int r3, [ LibSel_BG_Slide_right_Pic_ID ]
OUT 40,0
ld int [ LibSel_Center_Pic_Wid ], r3
'��ȡ��
ld int r3, [ LibSel_BG_Slide_right_Pic_ID ]
OUT 41,0
ld int [ LibSel_Center_Pic_Hgt ], r3

ld int [ LibSel_Showpic_Paramater_3 ], 240
cal int sub [ LibSel_Showpic_Paramater_3 ], [ LibSel_Center_Pic_Wid ]
cal int div [ LibSel_Showpic_Paramater_3 ], 2
cal int add [ LibSel_Showpic_Paramater_3 ], [ LibSel_BG_Slide_offset ]

ld int [ LibSel_Showpic_Paramater_4 ], 320
cal int sub [ LibSel_Showpic_Paramater_4 ], [ LibSel_Center_Pic_Hgt ]
cal int div [ LibSel_Showpic_Paramater_4 ], 2

ld int r3, LibSel_showpic_Paramater
out 20, 0

ld int [ LibSel_Showpic_Paramater_2 ], [ LibSel_BG_Slide_Left_Pic_ID ]
cal int add [ LibSel_Showpic_Paramater_3 ], - 240

'ʹͼƬ����
'��ȡ��
ld int r3, [ LibSel_BG_Slide_Left_Pic_ID ]
OUT 40,0
ld int [ LibSel_Center_Pic_Wid ], r3
'��ȡ��
ld int r3, [ LibSel_BG_Slide_Left_Pic_ID ]
OUT 41,0
ld int [ LibSel_Center_Pic_Hgt ], r3

ld int [ LibSel_Showpic_Paramater_3 ], 240
cal int sub [ LibSel_Showpic_Paramater_3 ], [ LibSel_Center_Pic_Wid ]
cal int div [ LibSel_Showpic_Paramater_3 ], 2
cal int add [ LibSel_Showpic_Paramater_3 ], [ LibSel_BG_Slide_offset ]
cal int add [ LibSel_Showpic_Paramater_3 ], - 240

ld int [ LibSel_Showpic_Paramater_4 ], 320
cal int sub [ LibSel_Showpic_Paramater_4 ], [ LibSel_Center_Pic_Hgt ]
cal int div [ LibSel_Showpic_Paramater_4 ], 2

ld int r3, LibSel_showpic_Paramater
out 20, 0


ret
'EndBlock


;'//====================����======================//
LibSel_Selected_Animate:
'Block
endasm
dim shared LibSel_BG_Move_ShowPic, LibSel_BG_Move_HidePic
'��ʾ�Ķ���Щ
dim shared LibSel_Show_ScalOnBG_Run, LibSel_BG_Slide_run
dim shared LibSel_Selected_BOX_Move_Run
dim shared LibSel_Show_FlyOut_Transfer_Run
dim shared LibSel_UI_Constructor_Run
dim shared LibSel_ui_scroll_Run
dim shared LibSel_ui_scroll_Val '�����LibSel_ui_scroll_Run�Ĳ���
dim shared LibSel_ui_scroll_Val_temp

LibSel_ui_scroll_Val_temp = LibSel_ui_scroll_curOffset

LibSel_Out = 1
LibSel_j = 0
LibSel_increase = 0
while LibSel_Out

LibSel_increase = LibSel_increase + 2
LibSel_j = LibSel_j + LibSel_increase

if LibSel_j >= 120 then
	LibSel_j = 120
	LibSel_Out = 0
end if

asm



'//
cmp int [ vint_LibSel_BG_Slide_run ], 1
jpc nz LibSel_BG_Slide_NotRun
		ld int [ LibSel_BG_Slide_offset ], [ vint_LibSel_j ]
		call LibSel_BG_Slide:
LibSel_BG_Slide_NotRun:

'//
cmp int [ vint_LibSel_ui_scroll_Run ], 1
jpc nz LibSel_ui_scroll_NotRun
		ld int [ vint_LibSel_ui_scroll_curOffset ], [ vint_LibSel_ui_scroll_Val_temp ]
		ld int r1, [ vint_LibSel_ui_scroll_Val ]
		cal int mul r1, [ vint_LibSel_j ]
		cal int div r1, 120
		cal int add [ vint_LibSel_ui_scroll_curOffset ], r1
LibSel_ui_scroll_NotRun:


'//����ɳ��Ķ��� �ǰ������ۺ���һ��� vint_LibSel_Show_FlyOut_Transfer_run ���Ʒ���
cmp int [ vint_LibSel_Show_FlyOut_Transfer_run ], 0
jpc z LibSel_Show_FlyOut_Transfer_NotRun

	'��ӱ���ɫ
	ld int [ LibSel_FILLPAGE_Paramater_1 ], [ vint_LibSel_BG_Page ]
	ld int r3, LibSel_FILLPAGE_Paramater
	out 23, 0
	'showpic( LibSel_BG_Page, LibSel_CurBG_Pic, 0, 0, 240, 320, 0, 0, 1)
	ld int [ LibSel_ShowPic_Paramater_1 ], [ vint_LibSel_BG_Page ]
	ld int [ LibSel_ShowPic_Paramater_2 ], [ vint_LibSel_CurBG_Pic ]

	ld int [ LibSel_ShowPic_Paramater_5 ], 240
	ld int [ LibSel_ShowPic_Paramater_6 ], 320
	ld int [ LibSel_ShowPic_Paramater_7 ], 0
	ld int [ LibSel_ShowPic_Paramater_8 ], 0
	'ͼƬ����
	call LibSel_Center_Pic:
	ld int r3, LibSel_ShowPic_Paramater
	out 20, 0

		ld int [ LibSel_Show_FlyOut_Transfer_ToWord ], [ vint_LibSel_Show_FlyOut_Transfer_run ]
		ld int [ LibSel_Show_FlyOut_Transfer_X_Offset ], [ vint_LibSel_j ]
		'�������������xy�ò�ͬ�ķ�Χ��
		ld int [ LibSel_Show_FlyOut_Transfer_Y_Offset ], [ vint_LibSel_j ]
		call LibSel_Show_FlyOut_Transfer:
		
		ld int [ LibSel_UI_Constructor_FlyOut_Toward ], [ vint_LibSel_Show_FlyOut_Transfer_run ]
		ld int [ LibSel_UI_Constructor_FlyOut_Offset ], [ vint_LibSel_j ]
		'������������
		jmp LibSel_Show_ScalOnBG_NotRun
LibSel_Show_FlyOut_Transfer_NotRun:

'//��������Ҫ���ӵ�
cmp int [ vint_LibSel_Show_ScalOnBG_run ], 1
jpc nz LibSel_Show_ScalOnBG_Run_NoSlide
		ld int [ LibSel_Show_ScalOnBG_Offset ], [ vint_LibSel_j ]
		call LibSel_Show_ScalOnBG
		jmp LibSel_Show_ScalOnBG_NotRun
LibSel_Show_ScalOnBG_Run_NoSlide:
		call LibSel_Show_ScalOnBG_NoSlide
LibSel_Show_ScalOnBG_NotRun:

'������̶������е�
call LibSel_UI_Constructor



endasm
flippage( LibSel_BG_Page )
'msdelay( 30)
asm
ld int r3, 25
out 27, 0
endasm
wend

asm
ld int [ LibSel_UI_Constructor_FlyOut_Toward ], 0
ld int [ LibSel_UI_Constructor_FlyOut_Offset ], 0
endasm

LibSel_ui_scroll_curOffset = LibSel_ui_scroll_Val_temp + LibSel_ui_scroll_Val
LibSel_ui_scroll_Val = 0
'����
LibSel_ui_scroll_Run 		= 0
LibSel_Show_ScalOnBG_Run 	= 0
LibSel_BG_Slide_run 		= 0
LibSel_Selected_BOX_Move_Run	= 0
LibSel_Show_FlyOut_Transfer_Run = 0
LibSel_UI_Constructor_Run 		= 0
asm
ret
'EndBlock

;'//====================������������======================//
LibSel_Selected_BaseAnimate:
'Block


endasm
			'//�����ƶ�����
			LibSel_LastBG_Pic = LibSel_CurBG_Pic
			LibSel_CurBG_PicID = LibSel_CurSelected + LibSel_cur_PicOffset * 2
			LibSel_CurBG_Pic = loadres( LibSel_Lib_Name$, LibSel_CurBG_PicID)
			
			'���ñ����ƶ�
			LibSel_BG_Slide_run = 1
			if LibSel_CurMove > 0 then
			
				asm
				'����
				ld int [ LibSel_BG_Slide_toward ], 1
				ld int [ LibSel_BG_Slide_Left_Pic_ID ], [ vint_LibSel_CurBG_Pic ]
				ld int [ LibSel_BG_Slide_Right_Pic_ID ], [ vint_LibSel_LastBG_Pic ]
				endasm
			else
				asm
				'����
				ld int [ LibSel_BG_Slide_toward ], - 1
				ld int [ LibSel_BG_Slide_Left_Pic_ID ], [ vint_LibSel_LastBG_Pic ]
				ld int [ LibSel_BG_Slide_Right_Pic_ID ], [ vint_LibSel_CurBG_Pic ]
				endasm				
			end if
			LibSel_ui_scroll_Val = LibSel_ui_scroll_PreMove * LibSel_CurMove
			LibSel_ui_scroll_Run = 1

asm
ret
'EndBlock

data LibSel_Center_Pic_Wid dword 0
data LibSel_Center_Pic_Hgt dword 0
;'//===============ʹͼƬ���еļ������=================//
LibSel_Center_Pic:
'����Ҫ������ ֱ�Ӷ�ȡshowpic�Ĳ���
'Block
'��ȡ��
ld int r3, [ LibSel_showpic_Pic ]
OUT 40,0
ld int [ LibSel_Center_Pic_Wid ], r3

'��ȡ��
ld int r3, [ LibSel_showpic_Pic ]
OUT 41,0
ld int [ LibSel_Center_Pic_Hgt ], r3


ld int r0, 240
cal int sub r0, [ LibSel_Center_Pic_Wid ]
cal int div r0, 2
ld int [ LibSel_showpic_DesX ], r0

ld int r0, 320
cal int sub r0, [ LibSel_Center_Pic_Hgt ]
cal int div r0, 2
ld int [ LibSel_showpic_DesY ], r0

ret
'EndBlock


'//��������Callһ����ĺ��� ��Ϊ�������ױ�ջ

LibSel_CalTouchID:
endasm
'Block
dim shared LibSel_CalTouchID_CurSel, LibSel_CalTouchID_temp, LibSel_PicOffset_temp

if G_touch_y < 265 then
	if G_touch_y > 155 then
		
		if G_touch_X > 20 and G_touch_X < 100 then
		'2
		LibSel_CalTouchID_CurSel = 2
		else if G_touch_X > 140 and G_touch_X < 220 then
		'4
		LibSel_CalTouchID_CurSel = 4
		end if
	else if  G_touch_y > 34 and G_touch_y < 144 then
		
		if G_touch_X > 20 and G_touch_X < 100 then
		'1
		LibSel_CalTouchID_CurSel = 1
		else if G_touch_X > 140 and G_touch_X < 220 then
		'3
		LibSel_CalTouchID_CurSel = 3
		end if
		
	end if
	LibSel_CurMove = LibSel_CalTouchID_CurSel - LibSel_CurSelected
'��ʱ��֧�ֹ�����
else if G_touch_y > 280 and G_touch_y < 300 and G_touch_X > 20 and G_touch_X < 220  then
		
		G_touch_X = G_touch_X - 20 
		'����ƫ��
		if G_touch_X > LibSel_ui_scroll_Max_X then G_touch_X = LibSel_ui_scroll_Max_X
		
		'�Թ������Ĵ��������
		'LibSel_CalTouchID_temp 
		'����ǵ�ǰѡ�е�ͼƬλ�õ�id
		LibSel_CalTouchID_CurSel = G_touch_X  / LibSel_ui_scroll_PreMove
		
		LibSel_PicOffset_temp = LibSel_CalTouchID_CurSel / 2
		
		LibSel_Scroll_Support_MaxLoad = 6
		if LibSel_PicOffset_temp = LibSel_PicOffsetCount - 1 then
			LibSel_PicOffset_temp = LibSel_PicOffsetCount - 2
			LibSel_Scroll_Support_MaxLoad = 4
			
		else if LibSel_PicOffset_temp = LibSel_PicOffsetCount - 2 then
			LibSel_PicOffset_temp = LibSel_PicOffsetCount - 2
			
		end if
		asm
			call LibSel_Scroll_Support
		endasm
		'LibSel_CurMove = 0
'������Ĳ˵�����
else if G_touch_y > 300 then

	G_touch_id = G_touch_X / 24
	LibSel_CalTouchID_temp = G_touch_id * 24
	showpic( -1, LibSel_ui_menu_Pr, LibSel_CalTouchID_temp, 296, 24, 24, LibSel_CalTouchID_temp, 0, 1 )
	msdelay( 50)
	'ȷ��
	if G_touch_id = 0 then
			LibSel_QuitState = 1
			'��ԭ�����з���
	'ȡ��
	else if G_touch_id = 1 then
			LibSel_QuitState = 1
			freeres( LibSel_CurBG_Pic)
	'���
	else if G_touch_id = 2 then
			asm
				ld int [ vint_LibSel_Show_FlyOut_Transfer_run ], - 1
				call LibSel_Selected_Animate:
			endasm
			waitkey()
			asm
				ld int [ vint_LibSel_Show_FlyOut_Transfer_run ], 1
				call LibSel_Selected_Animate:
			endasm
	end if


	
end if

'EndBlock
asm
ret
'//================�Թ�������֧��==================//
LibSel_Scroll_Support:
'�Ѿ���������� LibSel_CurMove��ֵ �͵���ѡ���ͼƬid LibSel_CalTouchID_CurSel ���е�ǰƫ�� LibSel_PicOffset_temp
endasm
dim shared LibSel_Scroll_Support_MaxLoad

'���ҳ��ƫ��û��  ��ô��ֻ�� LibSel_CurMove
if LibSel_cur_PicOffset = LibSel_PicOffset_temp then

	asm
	ret
	endasm
end if
	LibSel_CurMove = ( LibSel_PicOffset_temp - LibSel_cur_PicOffset ) * 2

	LibSel_cur_PicOffset = LibSel_PicOffset_temp
	
'/���������ƶ�
LibSel_ui_scroll_Val = LibSel_ui_scroll_PreMove * LibSel_CurMove
'ֻ��ʾ�˹������Ķ���
LibSel_ui_scroll_Run = 1
	
		'�����Ϊ0  ��������ѭ�����ִ���
		LibSel_CurMove = 0
asm
call LibSel_Selected_Animate

;'//����ת������

call LibSel_ScalONE_and_CopyTOScal_Parameter_INIT
ld int [ LibSel_loadres_ID ], [ vint_LibSel_cur_PicOffset ]
cal int mul [ LibSel_loadres_ID ], 2

cal int add [ LibSel_loadres_ID ], 1
endasm

LibSel_Pos_ID = 1
LibSel_i = 0
while LibSel_i < LibSel_Scroll_Support_MaxLoad
		
		asm		
		call LibSel_ScalONE_and_CopyTOScal:
		
		cal int add [ LibSel_loadres_ID ], 1
		cal int add [ vint_LibSel_Pos_ID ], 1

		endasm
LibSel_i = LibSel_i + 1
wend

'/�������뵱ǰ����ͼƬ
freeres( LibSel_CurBG_Pic )

LibSel_CurBG_PicID = LibSel_CurSelected + LibSel_cur_PicOffset * 2
LibSel_CurBG_Pic = loadres( LibSel_Lib_Name$, LibSel_CurBG_PicID)

asm
ret

LibSel_QINGWUSHIWODECUNZAI:
endasm
'EndBlock
'EndBlock






