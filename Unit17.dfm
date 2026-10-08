object Form17: TForm17
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Event View - Nowe Zdarzenie'
  ClientHeight = 209
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 675
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 27
      Top = 4
      Width = 43
      Height = 15
      Caption = 'Pozycja:'
    end
    object Label27: TLabel
      Left = 158
      Top = 4
      Width = 18
      Height = 15
      Caption = 'Typ'
    end
    object Label28: TLabel
      Left = 236
      Top = 4
      Width = 57
      Height = 15
      Caption = 'Parametr 1'
    end
    object Label29: TLabel
      Left = 313
      Top = 4
      Width = 48
      Height = 15
      Caption = 'G'#322'o'#347'no'#347#263
    end
    object Label30: TLabel
      Left = 376
      Top = 4
      Width = 43
      Height = 15
      Caption = 'D'#322'ugo'#347#263
    end
    object Label31: TLabel
      Left = 443
      Top = 4
      Width = 57
      Height = 15
      Caption = 'Parametr 2'
    end
    object Label32: TLabel
      Left = 561
      Top = 4
      Width = 57
      Height = 15
      Caption = 'Parametr 3'
    end
    object Edit1: TEdit
      Left = 17
      Top = 21
      Width = 64
      Height = 22
      Alignment = taCenter
      AutoSize = False
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 0
      Text = '1:00:000'
    end
    object Edit16: TEdit
      Left = 117
      Top = 20
      Width = 100
      Height = 23
      Alignment = taCenter
      TabOrder = 1
      OnChange = Edit16Change
    end
    object Edit19: TEdit
      Left = 223
      Top = 20
      Width = 80
      Height = 23
      Alignment = taCenter
      TabOrder = 2
    end
    object Edit20: TEdit
      Left = 309
      Top = 20
      Width = 55
      Height = 23
      Alignment = taCenter
      TabOrder = 3
    end
    object Edit21: TEdit
      Left = 370
      Top = 20
      Width = 55
      Height = 23
      Alignment = taCenter
      TabOrder = 4
    end
    object Edit22: TEdit
      Left = 431
      Top = 20
      Width = 80
      Height = 23
      Alignment = taCenter
      TabOrder = 5
    end
    object Edit23: TEdit
      Left = 517
      Top = 20
      Width = 150
      Height = 23
      Alignment = taCenter
      TabOrder = 6
    end
  end
  object Button1: TButton
    Left = 511
    Top = 175
    Width = 75
    Height = 25
    Caption = 'Zastosuj'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 592
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Anuluj'
    TabOrder = 2
    OnClick = Button2Click
  end
  object CardPanel1: TCardPanel
    Left = 0
    Top = 49
    Width = 145
    Height = 160
    Align = alLeft
    ActiveCard = Note
    Caption = 'CardPanel1'
    TabOrder = 3
    object Note: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Note'
      CardIndex = 0
      TabOrder = 0
      object Label2: TLabel
        Left = 30
        Top = 9
        Width = 78
        Height = 15
        Caption = 'Wybierz d'#378'w'#281'k'
      end
      object Label3: TLabel
        Left = 16
        Top = 56
        Width = 110
        Height = 15
        Caption = 'Ustaw G'#322'o'#347'no'#347#263' nuty'
      end
      object Label4: TLabel
        Left = 17
        Top = 104
        Width = 107
        Height = 15
        Caption = 'Ustaw d'#322'ugo'#347#263' nuty:'
      end
      object ComboBox1: TComboBox
        Left = 36
        Top = 27
        Width = 66
        Height = 23
        ItemIndex = 0
        TabOrder = 0
        Text = 'C-1'
        Items.Strings = (
          'C-1'
          'C#-1'
          'D-1'
          'D#-1'
          'E-1'
          'F-1'
          'F#-1'
          'G-1'
          'G#-1'
          'A-1'
          'A#-1'
          'B-1'
          'C0'
          'C#0'
          'D0'
          'D#0'
          'E0'
          'F0'
          'F#0'
          'G0'
          'G#0'
          'A0'
          'A#0'
          'B0'
          'C1'
          'C#1'
          'D1'
          'D#1'
          'E1'
          'F1'
          'F#1'
          'G1'
          'G#1'
          'A1'
          'A#1'
          'B1'
          'C2'
          'C#2'
          'D2'
          'D#2'
          'E2'
          'F2'
          'F#2'
          'G2'
          'G#2'
          'A2'
          'A#2'
          'B2'
          'C3'
          'C#3'
          'D3'
          'D#3'
          'E3'
          'F3'
          'F#3'
          'G3'
          'G#3'
          'A3'
          'A#3'
          'B3'
          'C4'
          'C#4'
          'D4'
          'D#4'
          'E4'
          'F4'
          'F#4'
          'G4'
          'G#4'
          'A4'
          'A#4'
          'B4'
          'C5'
          'C#5'
          'D5'
          'D#5'
          'E5'
          'F5'
          'F#5'
          'G5'
          'G#5'
          'A5'
          'A#5'
          'B5'
          'C6'
          'C#6'
          'D6'
          'D#6'
          'E6'
          'F6'
          'F#6'
          'G6'
          'G#6'
          'A6'
          'A#6'
          'B6'
          'C7'
          'C#7'
          'D7'
          'D#7'
          'E7'
          'F7'
          'F#7'
          'G7'
          'G#7'
          'A7'
          'A#7'
          'B7'
          'C8'
          'C#8'
          'D8'
          'D#8'
          'E8'
          'F8'
          'F#8'
          'G8'
          'G#8'
          'A8'
          'A#8'
          'B8'
          'C9'
          'C#9'
          'D9'
          'D#9'
          'E9'
          'F9'
          'F#9'
          'G9')
      end
      object Edit2: TEdit
        Left = 42
        Top = 75
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 1
        Text = '1-127'
      end
      object Edit3: TEdit
        Left = 42
        Top = 123
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 2
        Text = '480'
      end
    end
    object KeyAfter: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'KeyAfter'
      CardIndex = 1
      TabOrder = 1
      object Label5: TLabel
        Left = 16
        Top = 80
        Width = 110
        Height = 15
        Caption = 'Ustaw G'#322'o'#347'no'#347#263' nuty'
      end
      object Label6: TLabel
        Left = 34
        Top = 32
        Width = 78
        Height = 15
        Caption = 'Wybierz d'#378'w'#281'k'
      end
      object Edit4: TEdit
        Left = 44
        Top = 100
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '1-127'
      end
      object ComboBox2: TComboBox
        Left = 39
        Top = 51
        Width = 67
        Height = 23
        ItemIndex = 0
        TabOrder = 1
        Text = 'C-1'
        Items.Strings = (
          'C-1'
          'C#-1'
          'D-1'
          'D#-1'
          'E-1'
          'F-1'
          'F#-1'
          'G-1'
          'G#-1'
          'A-1'
          'A#-1'
          'B-1'
          'C0'
          'C#0'
          'D0'
          'D#0'
          'E0'
          'F0'
          'F#0'
          'G0'
          'G#0'
          'A0'
          'A#0'
          'B0'
          'C1'
          'C#1'
          'D1'
          'D#1'
          'E1'
          'F1'
          'F#1'
          'G1'
          'G#1'
          'A1'
          'A#1'
          'B1'
          'C2'
          'C#2'
          'D2'
          'D#2'
          'E2'
          'F2'
          'F#2'
          'G2'
          'G#2'
          'A2'
          'A#2'
          'B2'
          'C3'
          'C#3'
          'D3'
          'D#3'
          'E3'
          'F3'
          'F#3'
          'G3'
          'G#3'
          'A3'
          'A#3'
          'B3'
          'C4'
          'C#4'
          'D4'
          'D#4'
          'E4'
          'F4'
          'F#4'
          'G4'
          'G#4'
          'A4'
          'A#4'
          'B4'
          'C5'
          'C#5'
          'D5'
          'D#5'
          'E5'
          'F5'
          'F#5'
          'G5'
          'G#5'
          'A5'
          'A#5'
          'B5'
          'C6'
          'C#6'
          'D6'
          'D#6'
          'E6'
          'F6'
          'F#6'
          'G6'
          'G#6'
          'A6'
          'A#6'
          'B6'
          'C7'
          'C#7'
          'D7'
          'D#7'
          'E7'
          'F7'
          'F#7'
          'G7'
          'G#7'
          'A7'
          'A#7'
          'B7'
          'C8'
          'C#8'
          'D8'
          'D#8'
          'E8'
          'F8'
          'F#8'
          'G8'
          'G#8'
          'A8'
          'A#8'
          'B8'
          'C9'
          'C#9'
          'D9'
          'D#9'
          'E9'
          'F9'
          'F#9'
          'G9')
      end
    end
    object Controller: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Controller'
      CardIndex = 2
      TabOrder = 2
      object Label7: TLabel
        Left = 23
        Top = 33
        Width = 97
        Height = 15
        Caption = 'Wybierz Kontroller'
      end
      object Label8: TLabel
        Left = 24
        Top = 81
        Width = 83
        Height = 15
        Caption = 'Ustaw Parametr'
      end
      object ComboBox3: TComboBox
        Left = 8
        Top = 51
        Width = 127
        Height = 23
        ItemIndex = 0
        TabOrder = 0
        Text = '1-Modulation'
        Items.Strings = (
          '1-Modulation'
          '2-Breath Controller'
          '3-Undefined'
          '4-Foot Controller'
          '5-Portamento Time'
          '6-Data Entry MSB'
          '7-Main Volume'
          '8-Balance'
          '9-Undefined'
          '10-Panpot'
          '11-Expression'
          '12-Effect Control 1'
          '13-Effect Control 2'
          '14-Undefined'
          '15-Undefined'
          '16-General Purpose 1'
          '17-General Purpose 2'
          '18-General Purpose 3'
          '19-General Purpose 4'
          '20-Undefined'
          '21-Undefined'
          '22-Undefined'
          '23-Undefined'
          '24-Undefined'
          '25-Undefined'
          '26-Undefined'
          '27-Undefined'
          '28-Undefined'
          '29-Undefined'
          '30-Undefined'
          '31-Undefined'
          '32-Bank Select LSB'
          '33-Modulation LSB'
          '34-Breath LSB'
          '35-Undefined'
          '36-Foot LSB'
          '37-Portamento Time LSB'
          '38-Data Entry LSB'
          '39-Volume LSB'
          '40-Balance LSB'
          '41-Undefined'
          '42-Pan LSB'
          '43-Expression LSB'
          '44-Effect 1 LSB'
          '45-Effect 2 LSB'
          '46-Undefined'
          '47-Undefined'
          '48-General Purpose 1 LSB'
          '49-General Purpose 2 LSB'
          '50-General Purpose 3 LSB'
          '51-General Purpose 4 LSB'
          '52-Undefined'
          '53-Undefined'
          '54-Undefined'
          '55-Undefined'
          '56-Undefined'
          '57-Undefined'
          '58-Undefined'
          '59-Undefined'
          '60-Undefined'
          '61-Undefined'
          '62-Undefined'
          '63-Undefined'
          '64-Sustain'
          '65-Portamento On/Off'
          '66-Sostenuto'
          '67-Soft pedal'
          '68-Legato Footswitch'
          '69-Hold 2'
          '70-Sound Variation'
          '71-Harmonic Content (Resonance)'
          '72-Release Time'
          '73-Attack Time'
          '74-Brightness (Cutoff)'
          '75-Decay Time'
          '76-Vibrato Rate'
          '77-Vibrato Depth'
          '78-Vibrato Delay'
          '79-Sound Controller 10'
          '80-General Purpose 5'
          '81-General Purpose 6'
          '82-General Purpose 7'
          '83-General Purpose 8'
          '84-Portamento Control'
          '85-Undefined'
          '86-Undefined'
          '87-Undefined'
          '88-High Resolution Velocity Prefix'
          '89-Undefined'
          '90-Undefined'
          '91-Reverb Send Level'
          '92-Tremolo Depth'
          '93-Chorus Send Level'
          '94-Variation/Celeste Depth'
          '95-Phaser Depth'
          '96-Data Increment'
          '97-Data Decrement'
          '98-NRPN LSB'
          '99-NRPN MSB'
          '100-RPN LSB'
          '101-RPN MSB'
          '102-Undefined'
          '103-Undefined'
          '104-Undefined'
          '105-Undefined'
          '106-Undefined'
          '107-Undefined'
          '108-Undefined'
          '109-Undefined'
          '110-Undefined'
          '111-Undefined'
          '112-Undefined'
          '113-Undefined'
          '114-Undefined'
          '115-Undefined'
          '116-Undefined'
          '117-Undefined'
          '118-Undefined'
          '119-Undefined'
          '120-All Sound Off'
          '121-Reset All Controllers'
          '122-Local Control On/Off'
          '123-All Notes Off'
          '124-Omni Mode Off'
          '125-Omni Mode On'
          '126-Mono Mode On (Poly Off)'
          '127-Poly Mode On (Mono Off)')
      end
      object Edit5: TEdit
        Left = 38
        Top = 99
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 1
        Text = '1-127'
      end
    end
    object Patch: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Patch'
      CardIndex = 3
      TabOrder = 3
      object Label9: TLabel
        Left = 27
        Top = 7
        Width = 86
        Height = 15
        Caption = 'Wybierz Metod'#281
      end
      object Label10: TLabel
        Left = 32
        Top = 56
        Width = 71
        Height = 15
        Caption = 'Wybierz Bank'
      end
      object Label12: TLabel
        Left = 29
        Top = 105
        Width = 75
        Height = 15
        Caption = 'Wybierz Patch'
      end
      object ComboBox4: TComboBox
        Left = 8
        Top = 25
        Width = 127
        Height = 23
        ItemIndex = 0
        TabOrder = 0
        Text = 'Normal (MSB + LSB)'
        Items.Strings = (
          'Normal (MSB + LSB)'
          'Controller 0 (MSB)'
          'Controller 32 (LSB)')
      end
      object ComboBox5: TComboBox
        Left = 8
        Top = 75
        Width = 127
        Height = 23
        ItemIndex = 0
        TabOrder = 1
        Text = '1'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50'
          '51'
          '52'
          '53'
          '54'
          '55'
          '56'
          '57'
          '58'
          '59'
          '60'
          '61'
          '62'
          '63'
          '64'
          '65'
          '66'
          '67'
          '68'
          '69'
          '70'
          '71'
          '72'
          '73'
          '74'
          '75'
          '76'
          '77'
          '78'
          '79'
          '80'
          '81'
          '82'
          '83'
          '84'
          '85'
          '86'
          '87'
          '88'
          '89'
          '90'
          '91'
          '92'
          '93'
          '94'
          '95'
          '96'
          '97'
          '98'
          '99'
          '100'
          '101'
          '102'
          '103'
          '104'
          '105'
          '106'
          '107'
          '108'
          '109'
          '110'
          '111'
          '112'
          '113'
          '114'
          '115'
          '116'
          '117'
          '118'
          '119'
          '120'
          '121'
          '122'
          '123'
          '124'
          '125'
          '126'
          '127')
      end
      object ComboBox6: TComboBox
        Left = 9
        Top = 124
        Width = 127
        Height = 23
        ItemIndex = 0
        TabOrder = 2
        Text = 'Acoustic Grand Piano'
        Items.Strings = (
          'Acoustic Grand Piano'
          'Bright Acoustic Piano'
          'Electric Grand Piano'
          'Honky-tonk Piano'
          'Electric Piano 1'
          'Electric Piano 2'
          'Harpsichord'
          'Clavi'
          'Celesta'
          'Glockenspiel'
          'Music Box'
          'Vibraphone'
          'Marimba'
          'Xylophone'
          'Tubular Bells'
          'Dulcimer'
          'Drawbar Organ'
          'Percussive Organ'
          'Rock Organ'
          'Church Organ'
          'Reed Organ'
          'Accordion'
          'Harmonica'
          'Tango Accordion'
          'Acoustic Guitar (nylon)'
          'Acoustic Guitar (steel)'
          'Electric Guitar (jazz)'
          'Electric Guitar (clean)'
          'Electric Guitar (muted)'
          'Overdriven Guitar'
          'Distortion Guitar'
          'Guitar harmonics'
          'Acoustic Bass'
          'Electric Bass (finger)'
          'Electric Bass (pick)'
          'Fretless Bass'
          'Slap Bass 1'
          'Slap Bass 2'
          'Synth Bass 1'
          'Synth Bass 2'
          'Violin'
          'Viola'
          'Cello'
          'Contrabass'
          'Tremolo Strings'
          'Pizzicato Strings'
          'Orchestral Harp'
          'Timpani'
          'String Ensemble 1'
          'String Ensemble 2'
          'SynthStrings 1'
          'SynthStrings 2'
          'Choir Aahs'
          'Voice Oohs'
          'Synth Voice'
          'Orchestra Hit'
          'Trumpet'
          'Trombone'
          'Tuba'
          'Muted Trumpet'
          'French Horn'
          'Brass Section'
          'SynthBrass 1'
          'SynthBrass 2'
          'Soprano Sax'
          'Alto Sax'
          'Tenor Sax'
          'Baritone Sax'
          'Oboe'
          'English Horn'
          'Bassoon'
          'Clarinet'
          'Piccolo'
          'Flute'
          'Recorder'
          'Pan Flute'
          'Blown Bottle'
          'Shakuhachi'
          'Whistle'
          'Ocarina'
          'Lead 1 (square)'
          'Lead 2 (sawtooth)'
          'Lead 3 (calliope)'
          'Lead 4 (chiff)'
          'Lead 5 (charang)'
          'Lead 6 (voice)'
          'Lead 7 (fifths)'
          'Lead 8 (bass + lead)'
          'Pad 1 (new age)'
          'Pad 2 (warm)'
          'Pad 3 (polysynth)'
          'Pad 4 (choir)'
          'Pad 5 (bowed)'
          'Pad 6 (metallic)'
          'Pad 7 (halo)'
          'Pad 8 (sweep)'
          'FX 1 (rain)'
          'FX 2 (soundtrack)'
          'FX 3 (crystal)'
          'FX 4 (atmosphere)'
          'FX 5 (brightness)'
          'FX 6 (goblins)'
          'FX 7 (echoes)'
          'FX 8 (sci-fi)'
          'Sitar'
          'Banjo'
          'Shamisen'
          'Koto'
          'Kalimba'
          'Bag pipe'
          'Fiddle'
          'Shanai'
          'Tinkle Bell'
          'Agogo'
          'Steel Drums'
          'Woodblock'
          'Taiko Drum'
          'Melodic Tom'
          'Synth Drum'
          'Reverse Cymbal'
          'Guitar Fret Noise'
          'Breath Noise'
          'Seashore'
          'Bird Tweet'
          'Telephone Ring'
          'Helicopter'
          'Applause'
          'Gunshot')
      end
    end
    object ChannelAfter: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'ChannelAfter'
      CardIndex = 4
      TabOrder = 4
      object Label13: TLabel
        Left = 30
        Top = 56
        Width = 83
        Height = 15
        Caption = 'Ustaw Parametr'
      end
      object Edit6: TEdit
        Left = 46
        Top = 75
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '1-127'
      end
    end
    object Wheel: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Wheel'
      CardIndex = 5
      TabOrder = 5
      object Label14: TLabel
        Left = 30
        Top = 56
        Width = 83
        Height = 15
        Caption = 'Ustaw Parametr'
      end
      object Edit7: TEdit
        Left = 45
        Top = 75
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '0'
      end
    end
    object RPN: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'RPN'
      CardIndex = 6
      TabOrder = 6
      object Label15: TLabel
        Left = 25
        Top = 32
        Width = 92
        Height = 15
        Caption = 'Ustaw Parametr 1'
      end
      object Label17: TLabel
        Left = 25
        Top = 80
        Width = 92
        Height = 15
        Caption = 'Ustaw Parametr 2'
      end
      object Edit8: TEdit
        Left = 45
        Top = 51
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '16256'
      end
      object Edit9: TEdit
        Left = 45
        Top = 99
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 1
        Text = '16383'
      end
    end
    object NRPN: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'NRPN'
      CardIndex = 7
      TabOrder = 7
      object Label11: TLabel
        Left = 25
        Top = 32
        Width = 92
        Height = 15
        Caption = 'Ustaw Parametr 1'
      end
      object Label16: TLabel
        Left = 25
        Top = 80
        Width = 92
        Height = 15
        Caption = 'Ustaw Parametr 2'
      end
      object Edit10: TEdit
        Left = 45
        Top = 51
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '16256'
      end
      object Edit11: TEdit
        Left = 45
        Top = 99
        Width = 51
        Height = 23
        Alignment = taCenter
        TabOrder = 1
        Text = '16383'
      end
    end
    object SysBank: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'SysBank'
      CardIndex = 8
      TabOrder = 8
      object Label18: TLabel
        Left = 31
        Top = 57
        Width = 81
        Height = 15
        Caption = 'Ustaw Sys Bank'
      end
      object Edit12: TEdit
        Left = 40
        Top = 75
        Width = 63
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '1'
      end
    end
    object SysData: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'SysData'
      CardIndex = 9
      TabOrder = 9
      object Label19: TLabel
        Left = 14
        Top = 56
        Width = 111
        Height = 15
        Caption = 'Ustaw Sys Data (Hex)'
      end
      object Edit13: TEdit
        Left = 5
        Top = 75
        Width = 133
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = 'FFFF'
      end
    end
    object Text: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Text'
      CardIndex = 10
      TabOrder = 10
      object Label20: TLabel
        Left = 43
        Top = 56
        Width = 63
        Height = 15
        Caption = 'Wstaw tekst'
      end
      object Edit14: TEdit
        Left = 10
        Top = 75
        Width = 123
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = 'Tekst'
      end
    end
    object Lyrics: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Lyrics'
      CardIndex = 11
      TabOrder = 11
      object Label21: TLabel
        Left = 21
        Top = 56
        Width = 95
        Height = 15
        Caption = 'Wstaw tekst Lyrics'
      end
      object Edit15: TEdit
        Left = 11
        Top = 75
        Width = 121
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = 'Lyrics'
      end
    end
    object MCI: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'MCI'
      CardIndex = 12
      TabOrder = 12
      object Label22: TLabel
        Left = 14
        Top = 57
        Width = 114
        Height = 15
        Caption = 'Wstaw Komend'#281' MCI'
      end
      object ComboBox9: TComboBox
        Left = 8
        Top = 75
        Width = 127
        Height = 23
        ItemIndex = 0
        TabOrder = 0
        Text = 'Play'
        Items.Strings = (
          'Play'
          'Stop'
          'Pause'
          'Resume'
          'Seek'
          'Open'
          'Close'
          'Record'
          'Save'
          'Cut'
          'Copy'
          'Paste'
          'Delete'
          'Status'
          'Capability'
          'Info'
          'Set'
          'Setaudio'
          'Setvideo'
          'Step'
          'Freeze'
          'Unfreeze'
          'Realize'
          'Window'
          'Configure'
          'Escape')
      end
    end
    object Expression: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Expression'
      CardIndex = 13
      TabOrder = 13
      object Label23: TLabel
        Left = 29
        Top = 57
        Width = 86
        Height = 15
        Caption = 'Wstaw Ekspresj'#281
      end
      object Edit17: TEdit
        Left = 12
        Top = 75
        Width = 119
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '100'
      end
    end
    object Hairpin: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Hairpin'
      CardIndex = 14
      TabOrder = 14
      object Label24: TLabel
        Left = 27
        Top = 32
        Width = 87
        Height = 15
        Caption = 'Wybierz  Hairpin'
      end
      object Label25: TLabel
        Left = 27
        Top = 81
        Width = 88
        Height = 15
        Caption = 'Wybierz pozycj'#281':'
      end
      object Edit18: TEdit
        Left = 30
        Top = 99
        Width = 77
        Height = 23
        Alignment = taCenter
        TabOrder = 0
        Text = '1:00:000'
      end
      object ComboBox7: TComboBox
        Left = 20
        Top = 50
        Width = 103
        Height = 23
        TabOrder = 1
        Text = 'Cressendo'
        Items.Strings = (
          'Cressendo'
          'Decressendo')
      end
    end
    object Chord: TCard
      Left = 1
      Top = 1
      Width = 143
      Height = 158
      Caption = 'Chord'
      CardIndex = 15
      TabOrder = 15
      object Label26: TLabel
        Left = 32
        Top = 56
        Width = 77
        Height = 15
        Caption = 'Wybierz Akord'
      end
      object ComboBox8: TComboBox
        Left = 20
        Top = 74
        Width = 103
        Height = 23
        ItemIndex = 0
        TabOrder = 0
        Text = 'Major'
        Items.Strings = (
          'Major'
          'Minor'
          '7'
          'Major 7'
          'Minor 7'
          'Major 6'
          'Minor 6'
          'sus4'
          'sus2'
          '7sus4'
          'dim'
          'aug'
          'dim 7'
          'm7b5'
          '7b5'
          '7#5'
          '7b9'
          '7#9'
          '7#11'
          '7add13'
          '7b13'
          '9'
          'Major 9'
          'Minor 9'
          'add9'
          'Minor add9'
          '11'
          'Minor 11'
          '13'
          'Major 13'
          'Minor 13'
          'm69'
          '69'
          '1+5 (Power Chord)'
          '1+8 (Octave)'
          'No3 (Neutral)')
      end
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 151
    Top = 49
    Width = 519
    Height = 120
    Caption = ' Wyb'#243'r Zdarzenia '
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      'Note'
      'Key Aftertouch'
      'Controller'
      'Patch Change'
      'Channel Aftertouch'
      'Pitch Wheel'
      'RPN'
      'NRPN'
      'Sys Bank'
      'Sys Data'
      'Text'
      'Lyrics'
      'MCI Command'
      'Expression'
      'Hairpin'
      'Chord')
    TabOrder = 4
    OnClick = RadioGroup1Click
  end
end
