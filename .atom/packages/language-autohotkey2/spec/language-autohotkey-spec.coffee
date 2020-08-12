{WorkspaceView} = require 'atom'
LanguageAutohotkey = require '../lib/language-autohotkey'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "LanguageAutohotkey", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('language-autohotkey')

  describe "when the language-autohotkey:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.language-autohotkey')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'language-autohotkey:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.language-autohotkey')).toExist()
        atom.workspaceView.trigger 'language-autohotkey:toggle'
        expect(atom.workspaceView.find('.language-autohotkey')).not.toExist()
