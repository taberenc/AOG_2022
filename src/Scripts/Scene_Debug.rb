#==============================================================================
# ** Scene_Debug
#------------------------------------------------------------------------------
#  This class performs debug screen processing.
#==============================================================================

class Scene_Debug
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make windows
    @left_window = Window_DebugLeft.new
    @right_window = Window_DebugRight.new
    @help_window = Window_Base.new(192, 352, 448, 128)
    @help_window.contents = Bitmap.new(406, 96)
    # Restore previously selected item
    @left_window.top_row = $game_temp.debug_top_row
    @left_window.index = $game_temp.debug_index
    @right_window.mode = @left_window.mode
    @right_window.top_id = @left_window.top_id
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Refresh map
    $game_map.refresh
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @left_window.dispose
    @right_window.dispose
    @help_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update windows
    @right_window.mode = @left_window.mode
    @right_window.top_id = @left_window.top_id
    @left_window.update
    @right_window.update
    # Memorize selected item
    $game_temp.debug_top_row = @left_window.top_row
    $game_temp.debug_index = @left_window.index
    # If left window is active: call update_left
    if @left_window.active
      update_left
      return
    end
    # If right window is active: call update_right
    if @right_window.active
      update_right
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when left window is active)
  #--------------------------------------------------------------------------
  def update_left
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # Display help
      if @left_window.mode == 0
        text1 = "C (Enter) : ON / OFF"
        @help_window.contents.draw_text(4, 0, 406, 32, text1)
      else
        text1 = "Left : -1   Right : +1"
        text2 = "L (Pageup) : -10"
        text3 = "R (Pagedown) : +10"
        @help_window.contents.draw_text(4, 0, 406, 32, text1)
        @help_window.contents.draw_text(4, 32, 406, 32, text2)
        @help_window.contents.draw_text(4, 64, 406, 32, text3)
      end
      # Activate right window
      @left_window.active = false
      @right_window.active = true
      @right_window.index = 0
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when right window is active)
  #--------------------------------------------------------------------------
  def update_right
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Activate left window
      @left_window.active = true
      @right_window.active = false
      @right_window.index = -1
      # Erase help
      @help_window.contents.clear
      return
    end
    # Get selected switch / variable ID
    current_id = @right_window.top_id + @right_window.index
    # If switch
    if @right_window.mode == 0
      # If C button was pressed
      if Input.trigger?(Input::C)
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Reverse ON / OFF
        $game_switches[current_id] = (not $game_switches[current_id])
        @right_window.refresh
        return
      end
    end
    # If variable
    if @right_window.mode == 1
      # If right button was pressed
      if Input.repeat?(Input::RIGHT)
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Increase variables by 1
        $game_variables[current_id] += 1
        # Maximum limit check
        if $game_variables[current_id] > 99999999
          $game_variables[current_id] = 99999999
        end
        @right_window.refresh
        return
      end
      # If left button was pressed
      if Input.repeat?(Input::LEFT)
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Decrease variables by 1
        $game_variables[current_id] -= 1
        # Minimum limit check
        if $game_variables[current_id] < -99999999
          $game_variables[current_id] = -99999999
        end
        @right_window.refresh
        return
      end
      # If R button was pressed
      if Input.repeat?(Input::R)
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Increase variables by 10
        $game_variables[current_id] += 10
        # Maximum limit check
        if $game_variables[current_id] > 99999999
          $game_variables[current_id] = 99999999
        end
        @right_window.refresh
        return
      end
      # If L button was pressed
      if Input.repeat?(Input::L)
        # Play cursor SE
        $game_system.se_play($data_system.cursor_se)
        # Decrease variables by 10
        $game_variables[current_id] -= 10
        # Minimum limit check
        if $game_variables[current_id] < -99999999
          $game_variables[current_id] = -99999999
        end
        @right_window.refresh
        return
      end
    end
  end
end
#==============================================================================
# Save File System
# Author: Shdwlink1993
# Version: 1.12b
# Type: Game Enhancement, Save System
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# SFS Date 1.0b: 7/26/2008
# SFS Date 1.01b: 7/26/2008
# SFS Date 1.02b: 7/26/2008
# SFS Date 1.1b: 8/24/2008
# SFS Date 1.11b: 8/27/2008
# SFS Date 1.12b: 8/30/2008
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
# #  This work is protected by the following license:
# #----------------------------------------------------------------------------
# # 
# #  Creative Commons - Attribution-NonCommercial-ShareAlike 3.0 Unported
# #  ( http://creativecommons.org/licenses/by-nc-sa/3.0/ )
# # 
# #  You are free:
# # 
# #  to Share - to copy, distribute and transmit the work
# #  to Remix - to adapt the work
# # 
# #  Under the following conditions:
# # 
# #  Attribution. You must attribute the work in the manner specified by the
# #  author or licensor (but not in any way that suggests that they endorse you
# #  or your use of the work).
# # 
# #  Noncommercial. You may not use this work for commercial purposes.
# # 
# #  Share alike. If you alter, transform, or build upon this work, you may
# #  distribute the resulting work only under the same or similar license to
# #  this one.
# # 
# #  - For any reuse or distribution, you must make clear to others the license
# #    terms of this work. The best way to do this is with a link to this web
# #    page.
# # 
# #  - Any of the above conditions can be waived if you get permission from the
# #    copyright holder.
# # 
# #  - Nothing in this license impairs or restricts the author's moral rights.
# # 
# #----------------------------------------------------------------------------
# #
# # Note that if you share this file, even after editing it, you must still
# # give proper credit to shdwlink1993.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                                    ~= Function =~
#
# This script is designed to provide many different save game functions into
# your game, such as New Game Plus (NGP) functionality (As seen in Chrono
# Trigger), Multiple Disk System (MDS) (As seen in most PSX Final Fantasy
# Games), Infinite Save Files (Which should have been default in RMXP), and an
# Autosave and Autorestore System (ARS).
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                               ~= Version History =~
#
# Version 1.0b ---------------------------------------------------- [7/26/2008]
#  - New Game + added (Version 1.0)
#  - Multiple Disk System added (Version 1.0b)
#  - Infinite Save Files added (Version 1.0)
# Version 1.01b --------------------------------------------------- [7/26/2008]
#  - DREAM for Save Files (Blizzard) Support added (Version 1.0)
# Version 1.02b --------------------------------------------------- [7/26/2008]
#  - DREAM for Save Files (Blizzard) Support fixed (Version 1.1)
# Version 1.1b ---------------------------------------------------- [8/24/2008]
#  - New Game + updated (Version 1.1b)
#  - Multiple Disk System updated (Version 1.1b)
#  - Autosave/Restore System added (Version 1.0)
#  - Chaos Project Save Layout (Fantasist) Support added (Version 1.0b)
# Version 1.11b --------------------------------------------------- [8/27/2008]
#  - Fixed an error with Scene_Save's new functionality
# Version 1.12b --------------------------------------------------- [8/30/2008]
#  - Autosave/Restore System fixed (Version 1.01)
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                            ~= New Functionality =~
#
# Automatically, there is a new function added into Scene_Save. If you want to
# make the player REQUIRED to save the game at a particular point, you can use
# this script call:
#
# $scene = Scene_Save.new(true)
#
# This script call will make it so the player is forced to save the game to
# exit the menu.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                            ~= General Customization =~
#
# DREAM = Set this to true if you are using DREAM for Save Files by Blizzard.
#
# CPSL = Set this to true if you are using Chaos Project Save Layout by
# Fantasist.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                                ~= New Game Plus =~
#                                      - 1.1b -
#
# New Game Plus (Or New Game +) is a system first widely seen in Chrono Trigger
# for the SNES, although the system's roots go back to The Legend of Zelda's
# Second Quest. Essentially, once you beat the game, you can then use this
# option to restart the game with all your items and such. Characters will
# start the game with all the skills and stats they had in the previous file.
#
# To run the New Game Plus File creator, you need to, when the game is
# completed, have a call script that contains this:
#
# SL93.make_ngp
#
# Customization Options:
#
# NGP = Set this to false if you are NOT going to use NG+ at all in your game.
#
# NGP_SWI = Change this to the ID number of the Switch that you want to use for
# New Game + things, such as different dialog and such. The Switch will be set
# before the game starts.
#
# ACTORS = Set this to true if you want a NG+ start with all the Party Members
# from the previous save. Note that this does not alter their stats. All this
# affects is their ability to start in your party.
#
# GOLD = Set this to true if you want the party to start with all their money.
#
# TIME = Set this to true if you want the player to start with the same time
# they finished the game with.
#
# SWI_EXCEPTIONS = Put the ID of any Switch you want remaining in the NG+ into
# the array. Useful if you have an unlockable that the player should be able to
# start with.
#
# VAR_EXCEPTIONS = Put the ID of any Variable you want remaining in the NG+
# into the array.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                             ~= Multiple Disk System =~
#                                      - 1.1b -
#
# The Multiple Disk System is a system that was seen primarily on PlayStation
# games, in particular Final Fantasy's 7, 8, and 9. The reason this system
# would be useful in RMXP is because any attempt to create a Map when all 999
# are already in use will result in the editor crashing, which is a large
# problem for people designing a large game. To work around this, you would
# need to use the Multiple Disk System.
#
# WARNING: Before creating the second disk, be sure that all scripts, database
# entries, ect. that appear in more than one disk have all been finalized and
# will not be edited!
#
# To make the second Disk, simply copy and paste the project folder, open it
# and remove all the maps that you won't need.
#
# After compiling the game, place all the files into the same folder and
# rename them to Disk n.exe, Disk n.ini, and Disk n.rgssad instead of the
# previous name, where n is the disk number.
#
# Customization Options:
#
# MDS = Set this to false if you are NOT going to use the MDS in your game.
#
# PICTURE_NAME = Change this to the Picture name of the image you want
# displayed during the scene. The picture must be in the Picture Folder.
#
# DISK_VAR = Set this to the Variable ID that you are going to use for the save
# file's current disk number.
#
# CURRENT_DISK = Set this to the Disk Number of the disk you are editing. Do NOT
# use this Disk Number in any other disk in this game!
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                            ~= Infinite Save Files =~
#                                     - 1.0 -
#
# Infinite Save Files is a system that can be used to create and save, as the
# title suggests, infinite saves. The system will allow you to choose how many
# save files to allow (so I guess it's not QUITE infinite) for saving and
# loading purposes. If you are using Chaos Project Save Layout, then this
# system will be completely disabled.
#
# Customization Options:
#
# SAVE_FILES = Set this to the number of save files you want the game to use.
# Note that the higher this number is, the more lag is generated while trying
# to load it all. Also note that this variable affects the New Game Plus
# selection. If you don't want any changes, just leave it at 4.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                          ~= Autosave/Restore System =~
#                                     - 1.0 -
#
# The Autosave & Autorestore System is a system used (never by name) subtely by
# many, many games. If you enter a room (or a floor, ala MGS) at some point,
# die, hit the continue button, and are automatically restored to exactly the
# same way you were before then (without loading up a save file), you have been
# Auto-Saved and Restored, and probably have been for some time.
#
# To make an auto-save point, use this syntax:
#
# SL93.update_temp_save
#
# To restore the save point, you use this syntax:
#
# SL93.restore_temp_save
#
# If you want the temp file to be deleted after use, then just use this
# instead:
#
# SL93.restore_temp_save(true)
#
# Customization Options:
#
# ARS = Set this to true if you intend on using the Autosave/Restore System.
#
# TEMP_SAVE = Set this to the name of the temporary save file.
#
# ALL_TRANSFERS = Set this to true if you want the teleport command to
# automatically update the save file.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                               ~= Compatability =~
#
# - Low probability of working with the SDK.
# - Probably will not work with any Title Screen Modifications
# - Will not work with other Custom Save Systems or New Game Plus Systems
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#
#                             ~= Special Thanks =~
#
# - Blizzard, for a few script conventions and inspiration.
# - Phylomortis, because part of the ISF came from his script.
# - Memor-X, for requesting the Multiple Disk System.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

#==============================================================================
# ** SL93
#==============================================================================

module SL93
 
  # for compatablilty
  $sfs = 1.1
  #============================================================================
  # New Game Plus Configuration
  #============================================================================
  NGP = false
  NGP_SWI = 1
  ACTORS = true
  GOLD = true
  TIME = true
  SWI_EXCEPTIONS = [2, 50]
  VAR_EXCEPTIONS = [1, 2]
  #============================================================================
  # Multiple Disk System Configuration
  #============================================================================
  MDS = false
  DISK_VAR = 1
  CURRENT_DISK = 1
  PICTURE_NAME = ''
  #============================================================================
  # Infinite Save Files Configuration
  #============================================================================
  SAVE_FILES = 16
  #============================================================================
  # Autosave/Restore System Configuration
  #============================================================================
  ARS = false
  TEMP_SAVE = 'temp.save'
  ALL_TRANSFERS = false
  #============================================================================
  # Compatability With Other Systems
  #============================================================================
  CPSL = false
  DREAM = false
  #============================================================================
  # End Configuration
  #============================================================================
 
  def self.make_ngp
    if NGP
      $game_system.ngp = true
      if DREAM
        DREAM.save_game("Complete#{$game_temp.last_file_index+1}.ngp")
      else
        Scene_Save.save_game_data("Complete#{$game_temp.last_file_index+1}.ngp")
      end
	  $game_system.ngp = false
    else
      raise "Cannot create New Game+ File!\nPlease activate NGP system and retry." if $DEBUG
    end
  end
 
  def self.update_temp_save
    if ARS
      file = File.open(TEMP_SAVE, 'rb')
      Marshal.dump($game_system, file)
      Marshal.dump($game_switches, file)
      Marshal.dump($game_variables, file)
      Marshal.dump($game_self_switches, file)
      Marshal.dump($game_screen, file)
      Marshal.dump($game_actors, file)
      Marshal.dump($game_party, file)
      Marshal.dump($game_troop, file)
      Marshal.dump($game_map, file)
      Marshal.dump($game_player, file)
      file.close
    else
      raise "Cannot update Temp Save File!\nPlease activate ARS and retry." if $DEBUG
    end
  end
 
  def self.restore_temp_save(delete = false)
    if ARS
      if FileTest.exist?(TEMP_SAVE)
        file = File.open(TEMP_SAVE, 'rb')
        Marshal.load($game_system, file)
        Marshal.load($game_switches, file)
        Marshal.load($game_variables, file)
        Marshal.load($game_self_switches, file)
        Marshal.load($game_screen, file)
        Marshal.load($game_actors, file)
        Marshal.load($game_party, file)
        Marshal.load($game_troop, file)
        Marshal.load($game_map, file)
        Marshal.load($game_player, file)
        $game_map.setup($game_map.map_id)
        $game_player.center($game_player.x, $game_player.y)
        $game_party.refresh
        $game_system.bgm_play($game_system.playing_bgm)
        $game_system.bgs_play($game_system.playing_bgs)
        $game_map.update
        File.delete(TEMP_SAVE) if delete
        $scene = Scene_Map.new
      else
        # Start a new game.
        Graphics.frame_count = 0
        $game_temp          = Game_Temp.new
        $game_system        = Game_System.new
        $game_switches      = Game_Switches.new
        $game_variables     = Game_Variables.new
        $game_self_switches = Game_SelfSwitches.new
        $game_screen        = Game_Screen.new
        $game_actors        = Game_Actors.new
        $game_party         = Game_Party.new
        $game_troop         = Game_Troop.new
        $game_map           = Game_Map.new
        $game_player        = Game_Player.new
        $game_variables[DISK_VAR] = 1 if MDS
        $game_party.setup_starting_members
        $game_map.setup($data_system.start_map_id)
        $game_player.moveto($data_system.start_x, $data_system.start_y)
        $game_player.refresh
        $game_map.autoplay
        $game_map.update
        $scene = Scene_Map.new
      end
    else
      raise "Cannot restore Temp Save File!\nPlease activate ARS and retry." if $DEBUG
    end
  end
 
end

#==============================================================================
# ** Game_System
#==============================================================================

class Game_System
 
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :ngp if SL93::NGP
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias shdwlink1993_sfs_init initialize
  def initialize
    shdwlink1993_sfs_init
    @ngp = false if SL93::NGP
  end
end

#==============================================================================
# ** Window_SaveFile
#==============================================================================

class Window_SaveFile < Window_Base
 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     file_index : save file index
  #     filename   : file name
  #     position   : placement of window
  #--------------------------------------------------------------------------
  def initialize(file_index, filename, position)
    y = 64 + position * 104
    super(0, y, 640, 104)
    self.contents = Bitmap.new(width - 32, height - 32)
    @file_index = file_index
    if SL93::DREAM
      @filename = "#{SAVE_NAME}#{file_index + 1}.dream4" if SL93::DREAM
    else
      @filename = "Save#{@file_index + 1}.rxdata"
    end
    @time_stamp = Time.at(0)
    @file_exist = FileTest.exist?(@filename)
    if @file_exist
      begin
        file = File.open(@filename, 'r')
        @time_stamp = file.mtime
        if SL93::DREAM
          @characters, @frame_count, @game_system, @game_switches,
          @game_variables, @game_party, @game_map, @game_player = DREAM.data(file)
        else
          @characters = Marshal.load(file)
          @frame_count = Marshal.load(file)
          @game_system = Marshal.load(file)
          @game_switches = Marshal.load(file)
          @game_variables = Marshal.load(file)
        end
        @total_sec = @frame_count / Graphics.frame_rate
        file.close
        refresh
      rescue
        @file_exist = false
        refresh
        self.contents.draw_text(4, 20, 600, 32, 'Corrupt Data!', 1)
        time_string = @time_stamp.strftime('%Y/%m/%d %H:%M')
        self.contents.draw_text(4, 40, 600, 32, time_string, 2)
      end
    else
      refresh
    end
    @selected = false
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    # Draw file number
    self.contents.font.color = normal_color
    name = "File #{@file_index + 1}"
    self.contents.draw_text(4, 0, 600, 32, name)
    @name_width = contents.text_size(name).width
    # If save file exists
    if @file_exist
      # Draw character
      @characters.each_index {|i|
        bitmap = RPG::Cache.character(@characters[i][0], @characters[i][1])
        cw = bitmap.rect.width / 4
        ch = bitmap.rect.height / 4
        src_rect = Rect.new(0, 0, cw, ch)
        x = 300 - @characters.size * 32 + i * 64 - cw / 2
        self.contents.blt(x, 68 - ch, bitmap, src_rect)
      }
      # Draw play time
      hour = @total_sec / 60 / 60
      min = @total_sec / 60 % 60
      sec = @total_sec % 60
      time_string = sprintf('%02d:%02d:%02d', hour, min, sec)
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 8, 600, 32, time_string, 2)
      # Draw timestamp
      self.contents.font.color = normal_color
      time_string = @time_stamp.strftime('%Y/%m/%d %H:%M')
      self.contents.draw_text(4, 40, 600, 32, time_string, 2)
    else
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 40, 600, 32, 'No Data')
    end
  end
 
end

#==============================================================================
# ** Window_NGPFile
#==============================================================================

class Window_NGPFile < Window_Base
 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     file_index : save file index
  #     filename   : file name
  #     position   : placement of window
  #--------------------------------------------------------------------------
  def initialize(file_index, filename, position)
    y = 64 + position * 104
    super(0, y, 640, 104)
    self.contents = Bitmap.new(width - 32, height - 32)
    @file_index = file_index
    @filename = "Complete#{i+1}.ngp"
    @time_stamp = Time.at(0)
    @file_exist = FileTest.exist?(@filename)
    if @file_exist
      begin
        file = File.open(@filename, 'r')
        @time_stamp = file.mtime
        if DREAM
          @characters, @frame_count, @game_system, @game_switches,
          @game_variables, @game_party, @game_map, @game_player = DREAM.data(file)
        else
          @characters, @frame_count, @game_system, @game_switches,
          @game_variables, @game_party, @game_map, @game_player = Marshal.load(file)
        end
        @total_sec = @frame_count / Graphics.frame_rate
        file.close
        refresh
      rescue
        @file_exist = false
        refresh
        self.contents.draw_text(4, 20, 600, 32, 'Corrupt Data!', 1)
        time_string = @time_stamp.strftime('%Y/%m/%d %H:%M')
        self.contents.draw_text(4, 40, 600, 32, time_string, 2)
      end
    else
      refresh
    end
    @selected = false
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    # Draw file number
    self.contents.font.color = normal_color
    name = "Complete Game #{@file_index + 1}"
    self.contents.draw_text(4, 0, 600, 32, name)
    @name_width = contents.text_size(name).width
    # If save file exists
    if @file_exist
      # Draw character
      @characters.each_index {|i|
        bitmap = RPG::Cache.character(@characters[i][0], @characters[i][1])
        cw = bitmap.rect.width / 4
        ch = bitmap.rect.height / 4
        src_rect = Rect.new(0, 0, cw, ch)
        x = 300 - @characters.size * 32 + i * 64 - cw / 2
        self.contents.blt(x, 68 - ch, bitmap, src_rect)
      }
      # Draw play time
      hour = @total_sec / 60 / 60
      min = @total_sec / 60 % 60
      sec = @total_sec % 60
      time_string = sprintf('%02d:%02d:%02d', hour, min, sec)
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 8, 600, 32, time_string, 2)
      # Draw timestamp
      self.contents.font.color = normal_color
      time_string = @time_stamp.strftime('%Y/%m/%d %H:%M')
      self.contents.draw_text(4, 40, 600, 32, time_string, 2)
    else
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 40, 600, 32, 'No Data')
    end
  end

end

#==============================================================================
# ** Scene_Title
#==============================================================================

class Scene_Title
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # If battle test
    if $BTEST
      battle_test
      return
    end
    # Load database
    $data_actors        = load_data('Data/Actors.rxdata')
    $data_classes       = load_data('Data/Classes.rxdata')
    $data_skills        = load_data('Data/Skills.rxdata')
    $data_items         = load_data('Data/Items.rxdata')
    $data_weapons       = load_data('Data/Weapons.rxdata')
    $data_armors        = load_data('Data/Armors.rxdata')
    $data_enemies       = load_data('Data/Enemies.rxdata')
    $data_troops        = load_data('Data/Troops.rxdata')
    $data_states        = load_data('Data/States.rxdata')
    $data_animations    = load_data('Data/Animations.rxdata')
    $data_tilesets      = load_data('Data/Tilesets.rxdata')
    $data_common_events = load_data('Data/CommonEvents.rxdata')
    $data_system        = load_data('Data/System.rxdata')
    if FileTest.exist?('save.tmp')
      Scene_Load.read_save_data('save.tmp')
      return
    end
    # Make system object
    $game_system = Game_System.new
    # Make title graphic
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title($data_system.title_name)
    # Make command window
    s1 = 'New Game'
    if SL93::NGP
      s2 = 'New Game +'
      s3 = 'Continue'
      s4 = 'Shutdown'
    else
      s2 = 'Continue'
      s3 = 'Shutdown'
    end
    if SL93::NGP
      @command_window = Window_Command.new(192, [s1, s2, s3, s4])
    else
      @command_window = Window_Command.new(192, [s1, s2, s3])
    end
    @command_window.back_opacity = 160
    @command_window.x = 320 - @command_window.width / 2
    @command_window.y = 288
    # Continue enabled determinant
    # Check if at least one save file exists
    # If enabled, make @continue_enabled true; if disabled, make it false
    @continue_enabled = (0..SL93::SAVE_FILES-1).any? {|i|
      if SL93::DREAM
        FileTest.exist?("#{SAVE_NAME}#{file_index + 1}.dream4") if SL93::DREAM
      else
        FileTest.exist?("Save#{i+1}.rxdata") if !SL93::DREAM
      end
    }
    @newgameplus_enabled = (0..8).any? {|i|
      FileTest.exist?("Complete#{i+1}.ngp")
    } if SL93::NGP
    @newgame_enabled = true
    @newgame_enabled = (SL93::CURRENT_DISK == 1) if SL93::MDS
    # If continue is enabled, move cursor to 'Continue'
    # If disabled, display 'Continue' text in gray
    if @continue_enabled
      if SL93::NGP
        @command_window.index = 2
      else
        @command_window.index = 1
      end
    else
      if SL93::NGP
        @command_window.disable_item(2)
      else
        @command_window.disable_item(1)
      end
    end
    @command_window.disable_item(0) if !@newgame_enabled && SL93::MDS
    @command_window.disable_item(1) if !@newgameplus_enabled && SL93::NGP
    # Play title BGM
    $game_system.bgm_play($data_system.title_bgm)
    # Stop playing ME and BGS
    Audio.me_stop
    Audio.bgs_stop
    # Execute transition
    Graphics.transition
    # Main loop
    loop {
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      break if $scene != self
    }
    # Prepare for transition
    Graphics.freeze
    # Dispose of command window
    @command_window.dispose
    # Dispose of title graphic
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update command window
    @command_window.update
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by command window cursor position
      if SL93::NGP
        case @command_window.index
        when 0 then command_new_game
        when 1 then command_ngplus
        when 2 then command_continue
        when 3 then command_shutdown
        end
      else
        case @command_window.index
        when 0 then command_new_game
        when 1 then command_continue
        when 2 then command_shutdown
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Command: New Game
  #--------------------------------------------------------------------------
  def command_new_game
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Stop BGM
    Audio.bgm_stop
    # Reset frame count for measuring play time
    Graphics.frame_count = 0
    # Make each type of game object
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    $game_variables[SL93::DISK_VAR] = 1
    # Set up initial party
    $game_party.setup_starting_members
    # Set up initial map position
    $game_map.setup($data_system.start_map_id)
    # Move player to initial position
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    # Refresh player
    $game_player.refresh
    # Run automatic change for BGM and BGS set with map
    $game_map.autoplay
    # Update map (run parallel process event)
    $game_map.update
    # Switch to map screen
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # * Command: New Game +
  #--------------------------------------------------------------------------
  def command_ngplus
    # If continue is disabled
    unless @newgameplus_enabled
      # Play buzzer SE
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Switch to load screen
    $scene = Scene_New_Game_Plus.new
  end
end

#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map

  if SL93::MDS
    #--------------------------------------------------------------------------
    # * Main Processing
    #--------------------------------------------------------------------------
    alias shdwlink1993_mds_up update
    def update
	  $scene = Scene_MDS.new if $game_variables[SL93::DISK_VAR] !=
	      SL93::CURRENT_DISK
	  shdwlink1993_mds_up
    end
  end
 
  if SL93::ARS && SL93::ALL_TRANSFERS
    alias shdwlink1993_ars_transfer_player transfer_player
    #--------------------------------------------------------------------------
    # * Player Place Move
    #--------------------------------------------------------------------------
    def transfer_player
      shdwlink1993_ars_transfer_player
      SL93.update_temp_save
    end
  end
 
end

#==============================================================================
# ** Scene_MDS
#==============================================================================

class Scene_MDS
  if SL93::MDS
    def main
      if $game_variables[SL93::DISK_VAR] == SL93::CURRENT_DISK
        $scene = Scene_Map.new
        return
      end
      @mds = Sprite.new
      @mds.bitmap = Bitmap.new(640, 480)
      @pic = RPG::Cache.picture(SL93::PICTURE_NAME.to_s)
      self.bitmap.blt(0, 0, @pic, Rect.new(0, 0, picture.width, picture.height))
      @mds.bitmap.draw_text(0, 0, 320, 240, 'Changing Disk.')
      Scene_Save.save_game_data('save.tmp')
      Thread.new {system("Disk #{$game_variables[SL93::DISK_VAR]}")}
      15.times {Graphics.update}
      $scene = nil
    end
  end
end

#==============================================================================
# ** Scene_File
#==============================================================================

class Scene_File
  if !SL93::CPSL
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     help_text : text string shown in the help window
    #--------------------------------------------------------------------------
    def initialize(help_text)
      @help_text = help_text
    end
    #--------------------------------------------------------------------------
    # * Main Processing
    #--------------------------------------------------------------------------
    def main
      # Make help window
      @help_window = Window_Help.new
      @help_window.set_text(@help_text)
      # Make save file window
      @savefile_windows = []
      @cursor_displace = 0
      (0..3).each {|i|
        @savefile_windows.push(Window_SaveFile.new(i, make_filename(i), i))
      }
      # Select last file to be operated
      @file_index = 0
      @savefile_windows[@file_index].selected = true
      # Execute transition
      Graphics.transition
      # Main loop
      loop {
        # Update game screen
        Graphics.update
        # Update input information
        Input.update
        # Frame update
        update
        # Abort loop if screen is changed
        break if $scene != self
      }
      # Prepare for transition
      Graphics.freeze
      # Dispose of windows
      @help_window.dispose
      @savefile_windows.each {|win| win.dispose}
    end
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update
      # Update windows
      @help_window.update
      @savefile_windows.each {|win| win.update }
      # If C button was pressed
      if Input.trigger?(Input::C)
        # Call method: on_decision (defined by the subclasses)
        on_decision(make_filename(@file_index))
        $game_temp.last_file_index = @file_index
      # If B button was pressed
      elsif Input.trigger?(Input::B)
        # Call method: on_cancel (defined by the subclasses)
        on_cancel
      # If the down directional button was pressed
      elsif Input.repeat?(Input::DOWN)
        # If the down directional button pressed down is not a repeat,
        # or cursor position is more in front than the max save files.
        if Input.trigger?(Input::DOWN) || @file_index <
              SL93::SAVE_FILES - 1
          if @file_index == SL93::SAVE_FILES - 1
            $game_system.se_play($data_system.buzzer_se)
            return
          end
          @cursor_displace += 1
          if @cursor_displace == 4
            @cursor_displace = 3
            @savefile_windows.each {|win| win.dispose }
            @savefile_windows = []
            (0..3).each {|i|
              f = i - 2 + @file_index
              name = make_filename(f)
              @savefile_windows.push(Window_SaveFile.new(f, name, i))
              @savefile_windows[i].selected = false
            }
          end
          $game_system.se_play($data_system.cursor_se)
          @file_index = (@file_index + 1)
          @file_index = SL93::SAVE_FILES - 1 if @file_index ==
              SL93::SAVE_FILES
          (0..3).each {|i| @savefile_windows[i].selected = false }
          @savefile_windows[@cursor_displace].selected = true
          return
        end
      elsif Input.repeat?(Input::UP)
        if Input.trigger?(Input::UP) || @file_index > 0
          if @file_index == 0
            $game_system.se_play($data_system.buzzer_se)
            return
          end
          @cursor_displace -= 1
          if @cursor_displace == -1
            @cursor_displace = 0
            @savefile_windows.each {|win| win.dispose }
            @savefile_windows = []
            (0..3).each {|i|
              f = i - 1 + @file_index
              name = make_filename(f)
              @savefile_windows.push(Window_SaveFile.new(f, name, i))
              @savefile_windows[i].selected = false
            }
          end
          $game_system.se_play($data_system.cursor_se)
          @file_index = (@file_index - 1)
          @file_index = 0 if @file_index == -1
          (0..3).each {|i| @savefile_windows[i].selected = false }
          @savefile_windows[@cursor_displace].selected = true
          return
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Make File Name
    #     file_index : save file index (0-3)
    #--------------------------------------------------------------------------
    def make_filename(file_index)
      return "Save#{file_index + 1}.rxdata" if !SL93::DREAM
      return "#{SAVE_NAME}#{file_index + 1}.dream4" if SL93::DREAM
    end
  end
 
end

#==============================================================================
# ** Scene_Save
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias shdwlink1993_sfs_init initialize
  def initialize(cancel_lock = true)
    shdwlink1993_sfs_init
	  @cancel_lock = cancel_lock
  end
  #--------------------------------------------------------------------------
  # * Cancel Processing
  #--------------------------------------------------------------------------
  def on_cancel
    if @cancel_save
      $game_system.se_play($data_system.cancel_se)
      return
    else
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # If called from event
      if $game_temp.save_calling
        # Clear save call flag
        $game_temp.save_calling = false
        # Switch to map screen
        $scene = Scene_Map.new
      else
        # Switch to menu screen
        $scene = Scene_Menu.new(4)
      end
    end
  end
 
end

#==============================================================================
# ** Scene_Load
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Remake temporary object
    $game_temp = Game_Temp.new
    # Timestamp selects new file
    $game_temp.last_file_index = 0
    latest_time = Time.at(0)
    (0..SL93::SAVE_FILES-1).each {|i|
      filename = make_filename(i)
      if FileTest.exist?(filename)
        file = File.open(filename, 'r')
        if file.mtime > latest_time
          latest_time = file.mtime
          $game_temp.last_file_index = i
        end
        file.close
      end
    }
    super('Which file would you like to load?') if !SL93::CPSL
  end
 
end

#==============================================================================
# ** Scene_New_Game_Plus
#==============================================================================

class Scene_New_Game_Plus < Scene_File
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Remake temporary object
    $game_temp = Game_Temp.new
    # Timestamp selects new file
    $game_temp.last_file_index = 0
    latest_time = Time.at(0)
	if CPSL
	else
    (0..SL93::SAVE_FILES-1).each {|i|
      filename = make_filename(i)
      if FileTest.exist?(filename)
        file = File.open(filename, 'r')
        if file.mtime > latest_time
          latest_time = file.mtime
          $game_temp.last_file_index = i
        end
        file.close
      end
    }
	end
    super('Which file would you like to import?')
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make help window
    @help_window = Window_Help.new
    @help_window.set_text(@help_text)
    # Make save file window
    @savefile_windows = []
    @cursor_displace = 0
    (0..3).each {|i|
      @savefile_windows.push(Window_NGPFile.new(i, make_filename(i), i))
    }
    # Select last file to be operated
    @file_index = 0
    @savefile_windows[@file_index].selected = true
    # Execute transition
    Graphics.transition
    # Main loop
    loop {
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      break if $scene != self
    }
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @help_window.dispose
    @savefile_windows.each {|win| win.dispose}
  end
  #--------------------------------------------------------------------------
  # * Decision Processing
  #--------------------------------------------------------------------------
  def on_decision(filename)
    # If file doesn't exist
    unless FileTest.exist?(filename)
      # Play buzzer SE
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    # Play load SE
    $game_system.se_play($data_system.load_se)
    # Read save data
    file = File.open(filename, 'rb')
    if read_save_data(file)
      file.close
      # Set up initial party
      $game_party.setup_starting_members if !SL93::ACTORS
      # Set up initial map position
      $game_map.setup($data_system.start_map_id)
      # Move player to initial position
      $game_player.moveto($data_system.start_x, $data_system.start_y)
      # Refresh player
      $game_player.refresh
      # Run automatic change for BGM and BGS set with map
      $game_map.autoplay
      # Update map (run parallel process event)
      $game_map.update
	  # Close any possible loopholes
	  $game_system.ngp = false
      # Switch to map screen
      $scene = Scene_Map.new
    else
      # Reset game_system
      $game_system = Game_System.new
      # Play buzzer SE
      $game_system.se_play($data_system.buzzer_se)
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Cancel Processing
  #--------------------------------------------------------------------------
  def on_cancel
    # Play cancel SE
    $game_system.se_play($data_system.cancel_se)
    # Switch to title screen
    $scene = Scene_Title.new
  end
  #--------------------------------------------------------------------------
  # * Read Save Data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  def read_save_data(file)
    if DREAM
      DREAM.load_game(file)
    else
      characters           = Marshal.load(file)
      Graphics.frame_count = Marshal.load(file)
      $game_system         = Marshal.load(file)
      $game_switches       = Marshal.load(file)
      $game_variables      = Marshal.load(file)
      $game_actors         = Marshal.load(file)
      $game_party          = Marshal.load(file)
      $game_troop          = Marshal.load(file)
      $game_map            = Marshal.load(file)
    end
    Graphics.frame_count = 0 if !SL93::TIME
    return false if $game_system.ngp != true
    $game_switches_bk, $game_variables_bk = $game_switches, $game_variables
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    SL93::SWI_EXCEPTIONS.each {|s|
      $game_switches[s] = $game_switches_bk[s]
    }
    SL93::VAR_EXCEPTIONS.each {|v|
      $game_variables[v] = $game_variables_bk[v]
    }
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_party.lose_gold(9999999) if !SL93::GOLD
    $game_player        = Game_Player.new
    # Refresh party members
    $game_party.refresh
    return true
  end
end

#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  This class performs game over screen processing.
#==============================================================================

class Scene_Gameover
  if SL93::ARS
    #--------------------------------------------------------------------------
    # * Main Processing
    #--------------------------------------------------------------------------
    def main
      # Make game over graphic
      @sprite = Sprite.new
      @sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
      # Stop BGM and BGS
      $game_system.bgm_play(nil)
      $game_system.bgs_play(nil)
      # Play game over ME
      $game_system.me_play($data_system.gameover_me)
      # Execute transition
      Graphics.transition(120)
      c1 = 'Retry'
      c2 = 'Quit'
      @command_window = Window_Command.new(192, [c1, c2])
      @command_window.back_opacity = 160
      @command_window.x = 320 - @command_window.width / 2
      @command_window.y = 288
      # Main loop
      loop {
        # Update game screen
        Graphics.update
        # Update input information
        Input.update
        # Frame update
        update
        # Abort loop if screen is changed
        break if $scene != self
      }
      # Prepare for transition
      Graphics.freeze
      # Dispose of game over graphic
      @sprite.bitmap.dispose
      @sprite.dispose
      @command_window.dispose
      # Execute transition
      Graphics.transition(40)
      # Prepare for transition
      Graphics.freeze
      # If battle test
      $scene = nil if $BTEST
    end
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update
      @command_window.update
      if Input.trigger?(Input::C)
        case @command_window.index
        when 0 then SL93.restore_temp_save
        when 1 then $scene = Scene_Title.new
        end
      end
    end
  end
end