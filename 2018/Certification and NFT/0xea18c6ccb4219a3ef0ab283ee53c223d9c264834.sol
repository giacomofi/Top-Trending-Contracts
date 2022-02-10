['pragma solidity ^0.4.18;\n', '\n', '/**\n', '* Send 0.00025 to guess a random number from 0-9. Winner gets 80% of the pot.\n', '* 20% goes to the house. Note: house is supplying the initial pot so cry me a \n', '* river.\n', '*/\n', '\n', '\n', 'contract LuckyNumber {\n', '\n', '    address owner;\n', '    bool contractIsAlive = true;\n', '    uint8 winningNumber; \n', '    uint commitTime = 60;\n', '    uint nonce = 1;\n', '    \n', '    mapping (address => uint8) addressToGuess;\n', '    mapping (address => uint) addressToTimeStamp;\n', '    \n', '    \n', '    //modifier requiring contract to be live. Set bool to false to kill contract\n', '    modifier live() \n', '    {\n', '        require(contractIsAlive);\n', '        _;\n', '    }\n', '\n', '    // The constructor. \n', '    function LuckyNumber() public { \n', '        owner = msg.sender;\n', '    }\n', '    \n', '\n', '    //Used for the owner to add money to the pot. \n', '    function addBalance() public payable live {\n', '    }\n', '    \n', '\n', '    //explicit getter for "balance"\n', '    function getBalance() view external returns (uint) {\n', '        return this.balance;\n', '    }\n', '    \n', '    //getter for contractIsAlive\n', '    function getStatus() view external returns (bool) {\n', '        return contractIsAlive;\n', '    }\n', '\n', '    //allows the owner to abort the contract and retrieve all funds\n', '    function kill() \n', '    external \n', '    live \n', '    { \n', '        if (msg.sender == owner) {        \n', '            owner.transfer(this.balance);\n', '            contractIsAlive = false;\n', '            }\n', '    }\n', '\n', '    /**\n', '     * Pay 0.00025 eth to map your address to a guess. Sets time when guess can be checked\n', '     */\n', '    function takeAGuess(uint8 _myGuess) \n', '    public \n', '    payable\n', '    live \n', '    {\n', '        require(msg.value == 0.00025 ether);\n', '        addressToGuess[msg.sender] = _myGuess;\n', '        addressToTimeStamp[msg.sender] = now+commitTime;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Call to check your guess and claim reward. Call will fail if guess was set \n', '     * less than 60 seconds ago. Random number is generated and compared to the \n', '     * user guess. If the numbers match, user recieves 80% of the pot and the \n', '     * remainder is returned to the owner. Finally, the users guess is reset to \n', '     * invalid number\n', '     */\n', '    function checkGuess()\n', '    public\n', '    live\n', '    {\n', '        require(now>addressToTimeStamp[msg.sender]);\n', '        winningNumber = uint8(keccak256(now, owner, block.coinbase, block.difficulty, nonce)) % 10;\n', '        nonce = uint(keccak256(now)) % 10000;\n', '        uint8 userGuess = addressToGuess[msg.sender];\n', '        if (userGuess == winningNumber) {\n', '            msg.sender.transfer((this.balance*8)/10);\n', '            owner.transfer(this.balance);\n', '        }\n', '        \n', '        addressToGuess[msg.sender] = 16;\n', '        addressToTimeStamp[msg.sender] = 1;\n', '       \n', '        \n', '    }\n', '\n', '\n', '}//end of contract']