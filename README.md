# Masquerade
A game for the 2025 Winter Melon Jam made by:

- Chuggy (2D art)
- Naermor (Narrative, Game Design, Management)
- Sasoun (Music, Sound Effects)
- Usu (Programming, 3D models)

You can play it here: [naermor.itch.io/masquerade](https://naermor.itch.io/masquerade)

## Collaboration guidelines

Using github and git for collaboration has a couple of objectives:

- having the game and its code available for everyone in the team
- simplify collaboration, specially in regards of programming.

There will be times where using github may be too much, so if you find less complex and faster to share assets (music, art, etc) over discord or some other service, don't feel discouraged and just use that medium instead, after all we should look for what works best for us ദി ≽^⎚˕⎚^≼.

So with that out of the way, how can you use github effectively for this project?

### Cloning the game into your computer

To be able to run the game you will need to have **Godot** running in your machine as well as **Git** for all version control thingies. Once you have that select a folder where you want to store the project and run this command on your terminal (or git bash on windows):

```git clone https://github.com/NaviArgot/MelonJam2025.git```

After that open Godot, choose the Import option and open the folder where the cloned project is located as shown in this [tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/project_manager.html#opening-and-importing-projects)

### Having the game up to date

After cloning the project, you will need to stay up to date with the changes, doing that it's pretty simple as long as you haven't done code changes on your version of the project (for that read the next section).

To get the most recent version use this command;

```git pull```

This will retrieve the data from the current upstream repo (the github one) for the current branch (usually main), if you want to change those parameters use this:

```git pull <upstream> <branch>```

Just replace with the actual names.

**BEWARE**, using this will modify files and the project structure so you might lose any changes you made in your project.


### Collaborating
For coding collaboration we will use this rules:

- The ```main``` branch will always be ready for deployment
- All functionality will be programmed in its own branch and then merged. To push changes use ```git push -u origin <branch>``` and create a pull request on github.
- Try to chose functionality which code doesn't overlap with other features.
- The repo mantainer will be Usu, this entails revising push requests and accepting or rejecting them.
- Add a description to the pull request describing the changes made.

### Resources
- [Git Manual](https://git-scm.com/book/en/v2) (all you need are the first 3 chapters)
- [Godot Project Import Tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/project_manager.html#opening-and-importing-projects)
- [Github collaboration guide](https://medium.com/@jonathanmines/the-ultimate-github-collaboration-guide-df816e98fb67)
