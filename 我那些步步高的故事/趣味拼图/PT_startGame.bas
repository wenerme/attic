'//��ԴͼƬid
const PIC_BUT_UNPRESS = 4
const PIC_BUT_PRESSed = 5
const PIC_Start_menu = 6
'//�˵�id

'�����id�;����ͼƬ��ص�
const Menu_StartGame = 0
const Menu_ContinueGame = 1
const Menu_GameHelp = 2
const Menu_AboutGame = 3

const GAME_NOT_START = &hffffffff	'-1�Ĳ���  ò�Ʋ���ֱ��-1

'//������id����
const Touch_PicChunk =	1
const Touch_Top	     =  1'���������ʱ 
const Touch_Menu =	2
const Touch_Scan_ALL =	3'���ȫͼ

const Touch_User_Choice_left = 4
const Touch_User_Choice_right = 5
const Touch_User_Choiced = 6
'��Ϸʱ�Ĳ˵����
const Touch_Game_Menu_unfold = 7
const Touch_Game_Menu_fold  = 8

Dim G_key_x, G_key_y
Dim G_key_up, G_key_down, G_key_left, G_key_right
DIM G_key_escape, G_key_enter

Dim G_touch_x, G_touch_y	'�������X Y
Dim G_touch_ID	'���������idֵ

dim G_GAME_START	'�Ƿ�ʼ��Ϸ
dim G_GAME_OVER		'�Ƿ������Ϸ

dim G_gate_count	'�ܵĹ���
'ͼƬҳ�������
Dim G_main_pic, G_buff_page, G_bg_pic, G_logo_pic, G_num_pic, G_temp_pic, G_scan_pic, G_menu_p_pic, G_menu_u_pic

DIM G_User_pic 	'ÿ�ζ�����ʾ��һ��
Dim G_User_Posid '�û����Ƶ���һ���λ��
Dim G_User_MoveNum '�ƶ���ֵ
Dim G_User_Inkey	'�û�����

Dim G_User_Dont_MOVE	'��ʹ�ü�¼����ʱ�����Ϊ��
Dim G_User_PreMove 	'��һ�����ƶ�

Dim G_User_MoveCount  	'�ܵ��ƶ��ٶ�


dim G_User_Gate 	'��ǰ�ؿ�

dim G_User_Item1	'��Ʒ��  ����ϵͳδ���  ����ƣ����~
dim G_User_Item2
dim G_User_Item3
'�������ȫ��
dim mn$, drawWelComePage_buffPage, FileLenghth

setlcd( 240, 320)

DECLARE FUNCTION calTouchId()
declare function ShowNum( hPage, hImg, x, y, num)
declare function drawMainPage()
declare function getInput()
declare function revInput()
declare function drawWelComePage()
declare function getSequence()
declare function drawPictureChunk()




declare function startGate()

declare function passGateAnimate()

declare function gameMenu()
'������溯���ܲ���  ��ʱ������
declare function gameSave()

declare function getGateCount()

'//��ʼ��Ϸ
function startgame()
dim shared startgame_start, startgame_user_choice, startgame_menu_move
dim shared startgame_menu_pic, startgame_but_pic, startgame_butp_pic

dim shared startgame_i

dim shared getSequence_Sequence
startgame_but_pic = loadres( "PT_sys" + mn$, 4)
startgame_butp_pic = loadres( "PT_sys" + mn$, PIC_BUT_PRESSed)
startgame_menu_pic = loadres( "PT_sys" + mn$, PIC_Start_menu)

drawWelComePage_buffPage = createpage()

'��ȡ�ؿ�����
getGateCount()

startgame_user_choice = 0

'�����˵�ʱΪδ��ʼ��Ϸ
G_GAME_START = GAME_NOT_START

startgame_start = 1 
while startgame_start
	

	drawWelComePage()
	
	
	flippage( G_buff_page)
	'//��ȡ����
	G_User_Inkey = waitkey()
	getInput()
	revInput()
	
	'//startgame_user_choice�Ǵ�0��ʼ�ģ����˵����ƶ�
	
	startgame_menu_move = 0
	
	'�����о��������� �Ѽ��̻��ɴ�����
	if G_User_Inkey > 0 then
	
		if G_key_left then
			G_touch_id = Touch_User_Choice_left
		else if G_key_right then
			G_touch_id = Touch_User_Choice_right
		else if G_key_enter then	'ȷ��ѡ��ת���ɴ�����ѡ��
			G_touch_id = Touch_User_Choiced
		end if
		
	end if
	
	
	
	if 0 < startgame_user_choice and startgame_user_choice < 3 then
		if G_touch_id = Touch_User_Choice_left then
			 startgame_menu_move = -1
		else if G_touch_id = Touch_User_Choice_right then
			 startgame_menu_move = 1
		end if
	else if startgame_user_choice = 0 then
		if G_touch_id = Touch_User_Choice_left then
			 startgame_menu_move = 3
		else if G_touch_id = Touch_User_Choice_right then
			 startgame_menu_move = 1
		end if		
	
	else if startgame_user_choice = 3 then
		if G_touch_id = Touch_User_Choice_left then
			 startgame_menu_move = - 1
		else if G_touch_id = Touch_User_Choice_right then
			 startgame_menu_move = - 3
		end if		
	end if
	
	'startgame_user_choice = startgame_user_choice + startgame_menu_move
	
	if G_touch_id = Touch_User_Choiced then
		
		if startgame_user_choice = Menu_GameHelp then
			
			startgame_i = loadres( "PT_sys" + mn$, 7)
			
			SHOWPIC( -1, startgame_i, 0, 0, 240, 240, 0, 0, 1)
			
			while waitkey() <> KEY_ESCAPE
			wend
			
			FREERES( startgame_i)
		else if startgame_user_choice = Menu_AboutGame then
		
			startgame_i = loadres( "PT_sys" + mn$, 8)
			
			SHOWPIC( -1, startgame_i, 0, 0, 240, 240, 0, 0, 1)
			
			while waitkey() <> KEY_ESCAPE
			wend
			
			FREERES( startgame_i)
		
		else if startgame_user_choice = Menu_StartGame then
			
			G_GAME_START = Menu_StartGame
			G_User_MoveCount = 0
			G_User_Gate = 1
			
			SHOWPIC( -1, G_bg_pic, 0, 0, 240, 240, 0, 0, 1)
			
			locate( 1, 1)
			
			print "ƴͼ v 1.0"
			print "","��ʼ��Ϸ����"
			 
			print "","��ӭ���������ϷŶ��Ҫ"
			print "����ʲô���õĵط��������Ŷ��"
			
			print "","��ӭ����club.eebbk.com"
			print "","�ҵ�id�� a3160586"
			
			print ""
			print ""
			print "","�����������"
			
			waitkey()

			startGate()
			
			'startNewGame()
			
			'startgame_start = 1
					
		else if startgame_user_choice = Menu_continueGame then
			
			'������Ϸ��ȡ�� ��Ϸ״̬��ظ��� Menu_StartGame
			G_GAME_START = Menu_continueGame
			
				open "PT_SAV.sav" for binary as #1
					fileLength = 	lof( 1)		'//�ж��Ƿ�����ļ�
				if lof( 1)  then
					get #1, G_User_Gate
					get #1, getSequence_Sequence
				else
					'//�������ļ�ʱ����¿�ʼ
					G_GAME_START = GAME_NOT_START
				end if
	
				close #1
			if G_GAME_START = Menu_continueGame then
			
			G_User_MoveCount = 0
			
			startGate()
			end if
			'G_User_Gate = 1
			'continueGame()
			
		end if
		
	end if
	
	
wend

DELETEPAGE( drawWelComePage_buffPage)
'�����ǲ����ܴ�����������������  ������Щ��Դ�ͷ�����ǲ���




end function


'//���ƻ�ӭ���Ǹ�����
function drawWelComePage()

dim shared startgame_start, startgame_user_choice
dim shared startgame_menu_pic, startgame_but_pic, startgame_butp_pic

dim shared drawWelComePage_i, drawWelComePage_pos, drawWelComePage_j,drawWelComePage_buffPage

SHOWPIC( G_buff_page, G_bg_pic, 0, 0,240, 320 , 0, 0, 1)

'��ʾƴͼ����
RANDOMIZE( gettick())
temp_data = rnd( G_GATE_COUNT - 1 ) * 2 + 2
G_main_pic = loadres( "PT_res" + mn$, temp_data - 1)

getSequence()
vasm(" ld int [ vint_G_User_Posid], [ pic_8_posid]")
drawPictureChunk()

FREERES( G_main_pic)

SHOWPIC( G_buff_page, G_logo_pic, 8, 252, 60, 60 , 0, 0, 1)
'SHOWPIC( G_buff_page, G_scan_pic, 8, 252, 60, 60 , 0, 0, 1)

SHOWPIC( G_buff_page, startgame_but_pic, 47, 120, 30, 20 , 0, 0, 1)

SHOWPIC( G_buff_page, startgame_but_pic, 161, 120, 30, 20 , 30, 0, 1)

'�ƶ��Ĺ���

if startgame_menu_move <> 0 then
	
	if G_touch_id = Touch_User_Choice_left then
		SHOWPIC( G_buff_page, startgame_butp_pic, 47, 120, 30, 20 , 0, 0, 1)
	else
		SHOWPIC( G_buff_page, startgame_butp_pic, 161, 120, 30, 20 , 30, 0, 1)
	end if
	
	'���������õ��������ҳ��
	BITBLTPAGE( drawWelComePage_buffPage, G_buff_page)
	'drawWelComePage_transfer! = 0.5
	drawWelComePage_i = 84 * startgame_menu_move
	drawWelComePage_pos = startgame_user_choice * 84
	while drawWelComePage_i 
		
		
		SHOWPIC( drawWelComePage_buffPage, startgame_menu_pic, 77, 120, 84, 20 , drawWelComePage_pos, 0, 1)
		
		flippage( drawWelComePage_buffPage)
		
		STRETCHBLTPAGEEX(77, 120, 84, 20 , 77, 120, drawWelComePage_buffPage, G_buff_page)
		
		
		
	drawWelComePage_i = 0.7 * drawWelComePage_i
	drawWelComePage_pos = drawWelComePage_i + drawWelComePage_pos
	wend
	
	startgame_user_choice = startgame_user_choice + startgame_menu_move
end if

SHOWPIC( G_buff_page, startgame_menu_pic, 77, 120, 84, 20 , startgame_user_choice * 84, 0, 1)

SHOWPIC( G_buff_page, startgame_but_pic, 47, 120, 30, 20 , 0, 0, 1)

SHOWPIC( G_buff_page, startgame_but_pic, 161, 120, 30, 20 , 30, 0, 1)

end function

'// ��ȡͼƬ����������
function getSequence()

dim shared getSequence_Sequence

dim shared temp_data, detail_data, temp_i

open "hash_list.dat" for binary as #9

RANDOMIZE( gettick())

'������Ϸʱ����Ҫ�Ĳ���
if G_GAME_START = Menu_continueGame then
	temp_data = getSequence_Sequence
else
	temp_data = rnd(1023) * 9 * 4

	getSequence_Sequence = temp_data
end if

seek #9, temp_data

temp_data = 0
vasm(" ld int [vint_temp_i], pic_0_posid")
'vasm(" cal int sub [vint_temp_i], 4")
while temp_data < 9
	
	'get #9, detail_data
	asm
	
	LD int r1,9
	LD int r2,2147483647
	OUT 50,16
		ld int r0, [vint_temp_i]
		ld int [ r0 ], r3
		;out 0, r3
		;out 0, [vint_temp_i]
		cal int add [vint_temp_i], 4
		
	endasm
	
temp_data = temp_data + 1
wend

close #9
end function

'//��ȡ�ؿ�����
function getGateCount()

dim shared getGateCount_fn$

getGateCount_fn$ = "pt_res" + mn$

open getGateCount_fn$ for binary as #1
	
	get #1, G_GATE_COUNT
	
close #9

G_GATE_COUNT = G_GATE_COUNT / 2

end function

'//��Ҫ��ͼ���֣�����Ҫ����λ�ü���
function drawPictureChunk()
dim shared temp_data, detail_data, temp_i

dim shared pic_src_x, pic_src_y, pic_des_x, pic_des_y
dim shared pic_w, pic_h, pic_posid
'�ƺ���Ҫ�����ü������еķ���
dim shared pic_row, pic_list

temp_data = 0
vasm(" ld int [vint_temp_i], pic_0_posid")
while temp_data < 9

	asm
	ld int r0, [vint_temp_i]	'��ǰ��posid
	ld int [ vint_pic_posid] ,[ r0 ]
	endasm

	if temp_data = G_User_posid then
		vasm(" jmp Bu_Xian_Shi_Yong_Hu_Kong_Zhi_Na_Ge:")
	end if
	
	'posid �Ǵ�0��ʼ��	'

	pic_src_x = ( pic_posid mod 3) * 80
	pic_src_y = ( pic_posid / 3) * 80
	
	pic_des_x = ( temp_data mod 3) * 80
	pic_des_y = ( temp_data / 3) * 80
	
	SHOWPIC( G_buff_page, G_main_pic, pic_des_x, pic_des_y,80, 80 , pic_src_x, pic_src_y, 1)
	'print pic_posid;temp_data,dx;dy,sx;sy
	
	asm
	Bu_Xian_Shi_Yong_Hu_Kong_Zhi_Na_Ge:
	cal int add [vint_temp_i], 4	
	endasm
	
temp_data = temp_data + 1
wend

end function

'//������Ҫ��
function drawMainPage()
dim shared G_buff_page, G_bg_pic, G_scan_pic, G_num_pic, G_User_MoveCount

'����
SHOWPIC( G_buff_page, G_bg_pic, 0, 0,240, 320 , 0, 0, 1)

'����ͼ
SHOWPIC( G_buff_page, G_scan_pic, 8, 252, 60, 60 , 0, 0, 1)

'�û���ȱ��λ��
pic_des_x = ( G_User_pic mod 3) * 20 + 8
pic_des_y = ( G_User_pic / 3) * 20 + 252

SHOWPIC( G_buff_page, G_bg_pic, pic_des_x, pic_des_y, 20, 20 , pic_des_x, pic_des_y, 1)

'��ʾ�ƶ��˵Ĳ���
ShowNum( G_buff_page, G_num_pic, 240, 245, G_User_MoveCount)

'����˵��Ļ��ƻ���������  ��ʱֻ�ܽ�������
'�˵���һ���
SHOWPIC( G_buff_page, G_menu_u_pic, 234, 270, 6, 50 , 0, 0, 1)

end function

'//��ȡ�û�����
function getInput()

'/////===========����
if G_User_Inkey < 0 then
	G_touch_x = getpenposx( G_User_Inkey)
	G_touch_y = getpenposy( G_User_Inkey)
	
	calTouchId() '���㴥��
	
else
	G_touch_x = -1
	G_touch_y = -1
	G_touch_id = -1
end if
'/////=========== �����
VASM("LD INT r3,38") '//==UP
VASM("OUT 34,0")
VASM("LD INT [VINT_G_key_up],r3")

VASM("LD INT r3,40") '//==DOWN
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Down],r3")

VASM("LD INT r3,37") '//==left
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Left],r3")

VASM("LD INT r3,39") '//==right
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Right],r3")
'//==============������
VASM("LD INT r3,13") '//==ENTER
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Enter],r3")

VASM("LD INT r3,27") '//==ESCAPE
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Escape],r3")



end function

function picMove()

dim shared pic_row, pic_list, G_User_Posid, G_User_MoveNum

dim shared temp_data, detail_data, temp_i, temp_j, temp_k, temp_l
	
	if G_User_MoveNum = 0 then
		vasm(" jmp FINT_picMove_Exit")
	end if
	
	'//����ƶ��������Ϣ
	G_User_PreMove = G_User_MoveNum
	
	G_User_MoveCount = G_User_MoveCount + 1
	'//
	
	temp_data = G_User_MoveNum
	
	temp_j = G_User_Posid + temp_data
	temp_i = temp_j * 4
	temp_k = G_User_Posid * 4
	
	'�任λ��id
	asm
	
	ld int r1, pic_0_posid
	cal int add r1, [vint_temp_i]
	

	ld int r2, pic_0_posid
	cal int add r2, [vint_temp_k]
	
	ld int r0, [ r1 ]
	ld int [ r1 ], [ r2 ]
	ld int [ r2 ], r0	
	endasm
	G_User_Posid = G_User_Posid + temp_data
	
	vasm(" jmp FINT_picMove_Exit")	
	
end function

'//==�����ƶ�����ֵ
function calMoveNum()

dim shared pic_row, pic_list, G_User_Posid

dim shared temp_data, detail_data, temp_i, temp_j, temp_k, temp_l

	'//ʹ�ü�¼ʱ������
	if G_User_Dont_MOVE then
		G_User_Dont_MOVE = 0
		vasm(" JMP FINT_calMoveNum_EXIT:")
	end if


	pic_list = G_User_Posid mod 3
	pic_row = G_User_Posid / 3	
	
	G_User_MoveNum = 0

	'//����ʽ
	
	'���ĵ�
	temp_i = pic_list * 80 + 40
	temp_j = pic_row * 80 + 40
	'���
	temp_i = temp_i - G_touch_x
	temp_j = temp_j - G_touch_y

	'Ps �Ҿ���Ӧ�ÿ��Բ�Ҫ��ô��jmp�� ��ΪҪ�Ǻܺõĳ��� jmp��jmp��һ���ģ�������bb��~~����jmp��
	if G_touch_id = Touch_PicChunk then
		
		if -40 < temp_i and temp_i < 40	then
		
			if temp_j > 40 and temp_j < 120  then
				G_User_MoveNum = -3
				vasm(" JMP FINT_calMoveNum_EXIT:")
			else if -120 < temp_j and temp_j < -40  then
				G_User_MoveNum = 3
				vasm(" JMP FINT_calMoveNum_EXIT:")			
			end if
		
		else if -40 < temp_j and temp_j < 40	then
			
			if temp_i > 40 and temp_i < 120  then
				G_User_MoveNum = -1
				vasm(" JMP FINT_calMoveNum_EXIT:")
			else if -120 < temp_i and temp_i < -40  then
				G_User_MoveNum = 1
				vasm(" JMP FINT_calMoveNum_EXIT:")			
			end if		
			
		end if
		
	vasm(" JMP FINT_calMoveNum_EXIT:")
	end if
	'//����ʽ

	if G_key_down and pic_row > 0 then
		G_User_MoveNum = - 3
		
	else if G_key_up and pic_row < 2 then
		G_User_MoveNum = 3
		
	else if G_key_right and pic_list > 0 then
		G_User_MoveNum = - 1
	
	else if G_key_left and pic_list < 2 then
		G_User_MoveNum = 1
	end if

end function
'//����Ƿ�ͨ��
function gamePassGate()
dim shared pic_row, pic_list, G_User_Posid

dim shared temp_data, detail_data, temp_i, temp_j, temp_k, temp_l

temp_j = 0
detail_data = 0
temp_data = 0
vasm(" ld int [vint_temp_i], pic_0_posid")
while temp_data < 9

	asm
	ld int r0, [vint_temp_i]
	ld int [ vint_detail_data], [ r0 ]
	endasm
	'detail_data
	if detail_data = temp_data then
		temp_j = temp_j + 1
	end if
	
temp_i = temp_i + 4
temp_data = temp_data + 1
wend

'//===������һ��  �����в�����
if temp_j = 9 then
	passGateAnimate()
	'������һ��
	G_USer_GATE = G_USer_GATE + 1
	'����ֵ
	gamePassGate = 1
else
	gamePassGate = 0
end if

end function

function confirm( string$)

dim confirm_choice, confirm_key, confirm_x, confirm_y, confirm_str$

	locate( 2,1 )
  
	SHOWPIC( -1, G_bg_pic, 0, 0, 240, 240, 0, 0, 1)	
	
	print string$	
	
	locate( 15,29 )
	print  "��"

	locate( 15,1 )
	print  "��"	
	
	confirm_choice = -1
	
	while confirm_choice = -1
		
		confirm_key = waitkey()
		
		if confirm_key = KEY_ESCAPE then
			
			confirm_choice = 0
			
		else if confirm_key = key_enter then
			
			confirm_choice = 1
			
		else if confirm_key < 0 then '������ģʽ
			
			confirm_y = getpenposy( confirm_key) 
			confirm_x = getpenposx( confirm_key) 
			if 224 < confirm_y and confirm_y < 240 then
				
				if confirm_x < 16 then
					
					confirm_choice = 0
					
				else if confirm_x > 220 then
					
					confirm_choice = 1
					
				end if		
			end if
			
		end if

	wend
	
	confirm = confirm_choice
	
end function

'//������ܵ���Ϣ
function revInput()

dim shared pic_row, pic_list, G_User_Posid

dim shared temp_data, detail_data, temp_i, temp_j, temp_k, temp_l

if G_Key_Escape then
	
	
	if G_GAME_START = GAME_NOT_START then
	'������Ϸ  �����˵����˳���
		
		if confirm("ȷ���˳���Ϸ��") then
		
			end
			
		end if
		
	else
	'��Ϸ��ʱ���˳��� ������һ��
	G_User_MoveNum = - G_User_PreMove
	G_User_Dont_MOVE = 1
	
		
	end if
end if

'������ֻ������Ϸ����ʱ�Ŵ�����¼�
if G_GAME_START = GAME_NOT_START then
	vasm(" jmp fint_revInput_exit:")
end if


'���ȫͼ
if G_touch_id = Touch_Scan_all then
	showpic( -1, G_main_pic, 0, 0, 240, 240, 0, 0, 1)
	G_User_Dont_MOVE = 1
	G_User_MoveNum = 0
	waitkey()
	
end if

'չ���˵�
if G_touch_id = Touch_Game_Menu_unfold then
	gameMenu()
end if

end function

'//���㴥������id=====
function calTouchId()

'������yֵ�����ִ�Χ
if G_touch_y < 240 then
	G_touch_id = Touch_PicChunk' = Touch_Top 
	
	
	'��Ϸδ��ʼ��ʱ����Ҫ�����
	if G_GAME_START <> GAME_NOT_START then 
		goto Ru_Guo_You_Xi_Kai_Shi_Le_Qing_Wu_Shi_FcalTouchId
	end if
	
	if 120 < G_touch_y and G_touch_y < 140 then
		
		if 47 < G_touch_x and G_touch_x < 191 then
			
			if G_touch_x < 77 then
				G_touch_id = Touch_User_Choice_left
			else if G_touch_x < 161 then
				G_touch_id = Touch_User_Choiced
			else 
				G_touch_id = Touch_User_Choice_right
			end if
			
		end if
		
	end if
	
	Ru_Guo_You_Xi_Kai_Shi_Le_Qing_Wu_Shi_FcalTouchId:
	'//���Ͼ�����ϷΪ��ʼʱ��Ҫ�����
else
	G_touch_id = Touch_Menu
	
	'���ȫͼ
	if 252 < G_touch_y and G_touch_y < 312 and 8 < G_touch_x and G_touch_x < 68	then
		G_touch_id = Touch_Scan_all
	end if
	'���չ���˵�
	if 270 < G_touch_y and 234 < G_touch_x then
		G_touch_id = Touch_Game_Menu_unfold

	end if
	
	
		
end if

end function

'//ͼƬ���Ҷ���ģ�����ͼƬ��ʾ����
function ShowNum( hPage, hImg, x, y, num)

dim shared ShowNum_at_x, ShowNum_at_y, ShowNum_pic_wid, ShowNum_pic_heg, ShowNum_cur_num, ShowNum_num
dim shared ShowNum_hPage, ShowNum_hImg, ShowNum_i

ShowNum_hPage = hPage
ShowNum_hImg = hImg

ShowNum_at_x = x
ShowNum_at_y = y


ShowNum_pic_wid = getpicwid( himg) / 10
ShowNum_pic_heg = getpichgt( himg)

ShowNum_num = num
while ShowNum_num

	ShowNum_cur_num =  ShowNum_num mod 10
	ShowNum_at_x = ShowNum_at_x - ShowNum_pic_wid
		
	showpic( ShowNum_hPage, ShowNum_hImg, ShowNum_at_x, ShowNum_at_y, ShowNum_pic_wid, ShowNum_pic_heg, ShowNum_cur_num * ShowNum_pic_wid, 0, 1)
	
ShowNum_num = ShowNum_num / 10
wend

end function

function passGateAnimate()



end function

function specialGate()

dim shared specialGate_var

dim shared pic_row, pic_list, G_User_Posid

dim shared temp_data, detail_data, temp_i, temp_j, temp_k, temp_l

specialGate_var = 0

'//==����ص�����ֵ
if G_User_Gate = 6 then
	
	specialGate_var = 8

end if

'//==

if not specialGate_var then
	vasm(" jmp fint_specialGate_exit")
end if

temp_j = 0
detail_data = 0
temp_data = 0
vasm(" ld int [vint_temp_i], pic_0_posid")
while temp_data < 9

	asm
	ld int r0, [vint_temp_i]
	ld int [ vint_detail_data], [ r0 ]
	endasm

	if detail_data = specialGate_var then
		G_User_Posid = temp_data
	end if
	
temp_i = temp_i + 4
temp_data = temp_data + 1
wend

end function

'//==��Ϸʱ�Ĳ˵�
function gameMenu()
dim gameMenu_choice, gameMenu_last_choice, gameMenu_esc, gameMenu_x, gameMenu_y, gameMenu_key
dim shared temp_data, detail_data, temp_i, temp_j, temp_k, temp_l
'չ������
temp_i = 0
temp_j = getpicwid( G_menu_u_pic) - 6
while temp_j
	
	SHOWPIC( - 1, G_menu_u_pic, 234 - temp_i, 270, 46, 50 , 0, 0, 1)
MSDELAY( 100)
temp_j = temp_j *  0.5
temp_i = temp_j + temp_i
wend

'//����˵�
gameMenu_esc = 0
gameMenu_last_choice = 0
'�ֽ׶εĲ˵�ֻ������ѡ��~~~
while not gameMenu_esc
	
	G_User_Inkey = waitkey()
	getInput()
	
	if 270 < G_touch_y then
		
		'��ʵx���Բ�����������ģ������临����~
		'�Ǵ��ҵ������ģ���������߾���1
		'������ 1���� �˳� 2 ���Ǳ���
		if 220 < G_touch_x then
			gameMenu_choice = 1
		else if 200 < G_touch_x then
			gameMenu_choice = 2
		else 
			gameMenu_choice = 0	'�������ط�Ҳ�˳��˵�s
		end if
	else if G_touch_y > 0 then
			gameMenu_choice = 0	'�������ط�Ҳ�˳��˵�
	end if
	
	'����ֻ������ѡ���ֱ������������
	if G_key_left then
		gameMenu_choice = 2
	else if G_key_right then
		gameMenu_choice = 1
	else if G_key_escape then
		gameMenu_choice = 0
	else if G_key_enter then
		gameMenu_choice = gameMenu_last_choice
	end if
	
	
	'�ڴ�����ʱ��˫�����൱�ڵ���ȷ����
	if G_User_Inkey < 0  and gameMenu_last_choice = gameMenu_choice then
		G_key_enter = 1
	end if
	
	'����ѡ������
	if not gameMenu_esc and G_key_enter then
		if gameMenu_choice = 1 then
			'�˳��ؿ�
			if confirm("ȷ�Ϸ������˵���") then

				G_GAME_START = GAME_NOT_START
				gameMenu_choice = 0
			else
			'������˳���ԭ����
			STRETCHBLTPAGEEX( 0, 0, 240, 240, 0, 0, - 1, G_buff_page)
			end if		
		else 
			'��Ϸ����
			if confirm("ȷ�ϱ�����") then
				
				gameSave()
				
				gameMenu_choice = 0
			else
			'������˳���ԭ����
			STRETCHBLTPAGEEX( 0, 0, 240, 240, 0, 0, - 1, G_buff_page)
			end if
		end if
		
	end if
	
	'�����˳��˵������
	if gameMenu_choice then
		gameMenu_last_choice = gameMenu_choice
		
		'��ͼ
		SHOWPIC( - 1, G_menu_u_pic, 194, 270, 46, 50 , 0, 0, 1)
		SHOWPIC( - 1, G_menu_p_pic, 240 - gameMenu_last_choice * 20, 270, 20, 50 , 40 - gameMenu_last_choice * 20 , 0, 1)
	else
		gameMenu_esc = 1
	end if
	

wend

'�۵�����
temp_i = getpicwid( G_menu_u_pic) - 6
while temp_i
	
	SHOWPIC( - 1, G_menu_u_pic, 234 - temp_i, 270, 46, 50 , 0, 0, 1)
	'ɨ��ҳ��
	STRETCHBLTPAGEEX( 194, 270, 46 - temp_i, 50 , 194, 270, - 1, G_buff_page)

MSDELAY( 100)
temp_i = temp_i *  0.5

wend

end function

'//������Ϸ�ĺ���
function gameSave()
dim shared getSequence_Sequence, G_User_Gate

	open "PT_SAV.sav" for binary as #1
	
	put #1, G_User_Gate
	put #1, getSequence_Sequence
	
	close #1

end function

'//=========================ȫ�ֳ�ʼ����=========================================
IF GetEnv!() = Env_SIM Then
  mn$ = ".rlb"
Else
    mn$ = ".lib"
End IF

G_buff_page = Createpage()
'logoͼ
G_logo_pic = loadres( "PT_sys" + mn$, 1)
'ȫ�ֱ���
G_bg_pic = loadres( "PT_sys" + mn$, 2)
'����ͼ
G_num_pic = loadres( "PT_sys" + mn$, 3)
'δѡ�� ��Ϸʱ�Ĳ˵�
G_menu_u_pic = loadres( "PT_sys" + mn$, 9)
'ѡ��
G_menu_p_pic = loadres( "PT_sys" + mn$, 10)
'//��������
'�����С
FONT( FONT_16HEI)
'���屳��͸��
SETBKMODE( TRANSPARENT)
'������ɫ
COLOR( 4028394, 0, 0)


'G_User_Gate = 1

'//============================��ʼ��Ϸ======================================

startgame()

end
'//==================================================================




'//==**==��ʼ�ؿ�==**==//
function startGate()

vasm(" StartGate:")
'//========**********�ؿ���ʼ��ֵ***********=====
'//G_User_Gate�ǵ�ǰ�ؿ�ֵ
'//��ȡɢ��ֵ
getSequence()

vasm(" ld int [ vint_G_User_Posid], [ pic_8_posid]")

'//===����ؿ������⴦��   Ҫ�ı�G_User_Posid��ֵ  ��ʵֻ�Ǹı� G_User_Posid ��ֵ

specialGate()

'//===
'//����ȱ���Ǹ�λ��
asm
ld int r0, pic_0_posid
ld int r1, [ vint_G_User_Posid]

cal int mul r1, 4
cal int add r0, r1

ld int [ vint_G_User_Pic], [ r0 ]
endasm

'
temp_data = G_User_Gate * 2
G_main_pic = loadres( "PT_res" + mn$, temp_data - 1)


G_scan_pic = loadres( "PT_res" + mn$, temp_data)


vasm(" Tiao_Zhuan_Dao_Main_While_Lable:")
'//��������

drawMainPage()

'//����Сͼ����Щ

drawPictureChunk()

flippage( G_buff_page)

LOCATE( 1, 1)

'print G_user_pic;G_user_posid

'��ͨ��֮��
if gamePassGate() then

	freeres( G_main_pic)
	freeres( G_scan_pic)
	
	if G_User_Gate = G_GATE_COUNT then
		
		SHOWPIC( -1, G_bg_pic, 0, 0, 240, 240, 0, 0, 1)
		locate( 1, 1)
		print "��̫˧��̫������"
		print "��ϲ������ͨ�ء�"
		print "�����������������"
		
		waitkey()
		G_GAME_START = GAME_NOT_START
	end if
	
	vasm(" jmp StartGate")
end if
'//��ȡ����
G_User_Inkey = waitkey()


'//��ȡ��������
getInput()

'//�����û�����
revInput()

'//�����ƶ�����ֵ
calMoveNum()
'//����ͼƬ���˶�
picMove()

if G_GAME_START <> GAME_NOT_START	then

	vasm( " jmp Tiao_Zhuan_Dao_Main_While_Lable")
	
end if
'//=======����������========//
end function

asm



exit

;���Ĭ�Ͽ��������½ǵ��ĸ�
;������������ƴͼ��ɺ��λ�á���ʼ�ľ���λ�û���posid����
;��ȡres�ָ��ʱ�����˳��ָ��Ϊλ�������

data pic_0_posid dword 0
data pic_1_posid dword 1
data pic_2_posid dword 2
data pic_3_posid dword 3
data pic_4_posid dword 4
data pic_5_posid dword 5
data pic_6_posid dword 6
data pic_7_posid dword 8
User_Ctr_posid:
data pic_8_posid dword 7

endasm






















