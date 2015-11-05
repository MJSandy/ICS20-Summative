% The Tower - main classes and modules  V.0

% Data Manager
module dataManager
    export all

    var stream : int

    procedure openAction (filename : string)
	open : stream, "Assets/Data/Actions/" + filename, get
    end openAction

    procedure openBattler (filename : string)
	open : stream, "Assets/Data/Battlers/" + filename, get
    end openBattler

    procedure openVocab (filename : string)
	open : stream, "Assets/Data/Vocab/" + filename, get
    end openVocab

    procedure openWeapon (filename : string)
	open : stream, "Assets/Data/Weapons/" + filename, get
    end openWeapon

    procedure closeFile
	close : stream
    end closeFile

end dataManager

module inputManager
    import Input
    export all

    procedure waitInput
	var chars : array char of boolean
	loop
	    Input.KeyDown (chars)
	    exit when chars (KEY_ENTER)
	end loop
    end waitInput

end inputManager

% text printing
module textPrinting
    export all

    const SYSTEM_FONT := Font.New ("Mozart NBP:12")
    const SYSTEM_COLOR := green

    procedure textPrint (output : string, x, y : int)
	var X : int := x
	for i : 1 .. length (output)
	    Font.Draw (output (i), X, y, SYSTEM_FONT, SYSTEM_COLOR)
	    View.UpdateArea (X, y, X + 12, y + 12)
	    X += 6
	    if output (i) = " " then
		delay (40)
	    else
		delay (25)
	    end if
	end for

    end textPrint

end textPrinting

module sceneManager
end sceneManager

% User Interface
module UI
    import textPrinting, inputManager
    export all

    const MESSAGE_BG := "Assets/Graphics/GUI/Messagebg.bmp"

    procedure messageUpdate
	View.UpdateArea (0, 0, 320, 32)
    end messageUpdate

    procedure messageClear
	Draw.FillBox (0, 0, 320, 32, black)
	messageUpdate
    end messageClear

    procedure message (text : string)
	Draw.FillBox (0, 0, 320, 32, black)
	Pic.ScreenLoad (MESSAGE_BG, 0, 0, picMerge)
	messageUpdate
	textPrinting.textPrint (text, 6, 11)
	inputManager.waitInput
	messageClear
    end message
end UI

% Vocabulary
module vocab
    import dataManager
    export all
end vocab

% Actor class
class actor
    export all

    var HP, MP : int := 10 % current hp & mp values

    var maxHP, maxMP, bravery, faith, luck : int := 10 % base stats

    var path : string % selected path

    procedure setCharStats (mhp, mmp, brave, fait, luk : int)
	maxHP := mhp
	maxMP := mmp
	bravery := brave
	faith := fait
	luck := luk
    end setCharStats

    procedure changeHP (hp : int)
	HP += hp
    end changeHP

    procedure changemp (mp : int)
	MP += mp
    end changemp

    procedure changemhp (mhp : int)
	maxHP += mhp
    end changemhp

    procedure changemmp (mmp : int)
	maxMP += mmp
    end changemmp

    procedure changebrave (brave : int)
	bravery += brave
    end changebrave

    procedure changefaith (fait : int)
	faith += fait
    end changefaith

    procedure changeluk (luk : int)
	luck += luk
    end changeluk
end actor

% Battler class
class battler
    import dataManager, UI
    export all

    var name : string
    var HP, MP : int
    var command : int
    var maxHP, maxMP, bravery, faith, luck : int
    var hint1, hint2, hint3 : string

    procedure initialize (enemyFile : string)
	dataManager.openBattler (enemyFile + ".txt")
	get : dataManager.stream, name
	get : dataManager.stream, maxHP
	get : dataManager.stream, maxMP
	get : dataManager.stream, bravery
	get : dataManager.stream, faith
	get : dataManager.stream, luck
	get : dataManager.stream, hint1
	get : dataManager.stream, hint2
	get : dataManager.stream, hint3
	close : dataManager.stream
    end initialize

    procedure changeHP (hp : int)
	HP += hp
    end changeHP

    procedure changeMP (mp : int)
	MP += mp
    end changeMP

    procedure changeMHP (mhp : int)
	maxHP += mhp
    end changeMHP

    procedure changeMMP (mmp : int)
	maxMP += mmp
    end changeMMP

    procedure changeBrave (brave : int)
	bravery += brave
    end changeBrave

    procedure changeFaith (fait : int)
	faith += fait
    end changeFaith

    procedure changeLuk (luk : int)
	luck += luk
    end changeLuk

    procedure randCommand
	randint (command, 1, 3)
	if command = 1 then
	    UI.message (hint1)
	elsif command = 2 then
	    UI.message (hint2)
	elsif command = 3 then
	    UI.message (hint3)
	end if
    end randCommand

end battler

% scene battle
module sceneBattle
    import sceneManager, UI, vocab, actor, battler
    export all

    procedure battleProcess (enemy : string)
	var playerCommand : int
	var btr : ^battler
	new btr

	btr -> initialize (enemy)

	UI.message ("A " + btr -> name + " emerged!")

	loop
	    btr -> randCommand
	    UI.message ("What will you do?")
	    get playerCommand      
	    if playerCommand = 1 and btr -> command = 3 then
		UI.message ("Player wins!")
	    elsif playerCommand = 2 and btr -> command = 1 then
		UI.message ("Player wins!")
	    elsif playerCommand = 3 and btr -> command = 2 then
		UI.message ("Player wins!")
	    else
		UI.message ("Player loses...")
	    end if
	end loop
    end battleProcess

end sceneBattle

class weapon

