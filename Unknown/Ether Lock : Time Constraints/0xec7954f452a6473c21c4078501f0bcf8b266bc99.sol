['pragma solidity 0.4.8;\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    \n', '}\n', '\n', '\n', 'contract token {\n', '    /* Public variables of the token */\n', '    string public standard = &#39;AdsCash 0.1&#39;;\n', '    string public name;                                 //Name of the coin\n', '    string public symbol;                               //Symbol of the coin\n', '    uint8  public decimals;                              // No of decimal places (to use no 128, you have to write 12800)\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function token(\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    \n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        throw;     // Prevents accidental sending of ether\n', '    }\n', '}\n', '\n', ' contract ProgressiveToken is owned, token {\n', '    uint256 public constant totalSupply=30000000000;          // the amount of total coins avilable.\n', '    uint256 public reward;                                    // reward given to miner.\n', '    uint256 internal coinBirthTime=now;                       // the time when contract is created.\n', '    uint256 public currentSupply;                           // the count of coins currently avilable.\n', '    uint256 internal initialSupply;                           // initial number of tokens.\n', '    uint256 public sellPrice;                                 // price of coin wrt ether at time of selling coins\n', '    uint256 public buyPrice;                                  // price of coin wrt ether at time of buying coins\n', '    bytes32 internal currentChallenge;                        // The coin starts with a challenge\n', '    uint public timeOfLastProof;                              // Variable to keep track of when rewards were given\n', '    uint internal difficulty = 10**32;                          // Difficulty starts reasonably low\n', '    \n', '    mapping  (uint256 => uint256) rewardArray;                  //create an array with all reward values.\n', '   \n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function ProgressiveToken(\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '        uint256 initialSupply,\n', '        uint256 sellPrice,\n', '        uint256 buyPrice,\n', '        address centralMinter                                  \n', '    ) token ( tokenName, decimalUnits, tokenSymbol) {\n', '        if(centralMinter != 0 ) owner = centralMinter;    // Sets the owner as specified (if centralMinter is not specified the owner is \n', '                                                          // msg.sender)\n', '        balanceOf[owner] = initialSupply;                // Give the owner all initial tokens\n', '\ttimeOfLastProof = now;                           //initial time at which reward is given is the time when contract is created.\n', '\tsetPrices(sellPrice,buyPrice);                   // sets sell and buy price.\n', '        currentSupply=initialSupply;                     //updating current supply.\n', '        reward=22380;                         //initialising reward with initial reward as per calculation.\n', '        for(uint256 i=0;i<12;i++){                       // storing rewardValues in an array.\n', '            rewardArray[i]=reward;\n', '            reward=reward/2;\n', '        }\n', '        reward=getReward(now);\n', '    }\n', '    \n', '    \n', '    \n', '  \n', '   /* Calculates value of reward at given time */\n', '    function getReward (uint currentTime) constant returns (uint256) {\n', '        uint elapsedTimeInSeconds = currentTime - coinBirthTime;         //calculating timealpsed after generation of coin in seconds.\n', '        uint elapsedTimeinMonths= elapsedTimeInSeconds/(30*24*60*60);    //calculating timealpsed after generation of coin\n', '        uint period=elapsedTimeinMonths/3;                               // Period of 3 months elapsed after coin was generated.\n', '        return rewardArray[period];                                      // returning current reward as per period of 3 monts elapsed.\n', '    }\n', '\n', '    function updateCurrentSupply() private {\n', '        currentSupply+=reward;\n', '    }\n', '\n', '   \n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;                          // Check if the sender has enough balance\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;                // Check for overflows\n', '        reward=getReward(now);                                              //Calculate current Reward.\n', '        if(currentSupply + reward > totalSupply ) throw;                    //check for totalSupply.\n', '        balanceOf[msg.sender] -= _value;                                    // Subtract from the sender\n', '        balanceOf[_to] += _value;                                           // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took  \n', '        updateCurrentSupply();\n', '        balanceOf[block.coinbase] += reward;\n', '    }\n', '\n', '\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '            if(currentSupply + mintedAmount> totalSupply) throw;             // check for total supply.\n', '            currentSupply+=(mintedAmount);                                   //updating currentSupply.\n', '            balanceOf[target] += mintedAmount;                               //adding balance to recipient.\n', '            Transfer(0, owner, mintedAmount);\n', '            Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '\n', '\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;          //initialising sellPrice so that sell price becomes value of coins in Wei\n', '        buyPrice = newBuyPrice;            //initialising buyPrice so that buy price becomes value of coins in Wei\n', '    }\n', '    \n', '   function buy() payable returns (uint amount){\n', '        amount = msg.value / buyPrice;                     // calculates the amount\n', '        if (balanceOf[this] < amount) throw;               // checks if it has enough to sell\n', '        reward=getReward(now);                             //calculating current reward.\n', '        if(currentSupply + reward > totalSupply ) throw;   // check for totalSupply\n', '        balanceOf[msg.sender] += amount;                   // adds the amount to buyer&#39;s balance\n', '        balanceOf[this] -= amount;                         // subtracts amount from seller&#39;s balance\n', '        balanceOf[block.coinbase]+=reward;                 // rewards the miner\n', '        updateCurrentSupply();                             //update the current supply.\n', '        Transfer(this, msg.sender, amount);                // execute an event reflecting the change\n', '        return amount;                                     // ends function and returns\n', '    }\n', '\n', '    function sell(uint amount) returns (uint revenue){\n', '        if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell\n', '        reward=getReward(now);                             //calculating current reward.\n', '        if(currentSupply + reward > totalSupply ) throw;   // check for totalSupply.\n', '        balanceOf[this] += amount;                         // adds the amount to owner&#39;s balance\n', '        balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller&#39;s balance\n', '        balanceOf[block.coinbase]+=reward;                 // rewarding the miner.\n', '        updateCurrentSupply();                             //updating currentSupply.\n', '        revenue = amount * sellPrice;                      // amount (in wei) corresponsing to no of coins.\n', '        if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it&#39;s important\n', '            throw;                                         // to do this last to prevent recursion attacks\n', '        } else {\n', '            Transfer(msg.sender, this, amount);            // executes an event reflecting on the change\n', '            return revenue;                                // ends function and returns\n', '        }\n', '    }\n', '\n', '\n', '\n', '    \n', '    \n', '    function proofOfWork(uint nonce){\n', '        bytes8 n = bytes8(sha3(nonce, currentChallenge));    // Generate a random hash based on input\n', '        if (n < bytes8(difficulty)) throw;                   // Check if it&#39;s under the difficulty\n', '    \n', '        uint timeSinceLastProof = (now - timeOfLastProof);   // Calculate time since last reward was given\n', '        if (timeSinceLastProof <  5 seconds) throw;          // Rewards cannot be given too quickly\n', '        reward=getReward(now);                               //Calculate reward.\n', '        if(currentSupply + reward > totalSupply ) throw;     //Check for totalSupply\n', '        updateCurrentSupply();                               //update currentSupply\n', '        balanceOf[msg.sender] += reward;                      //rewarding the miner.\n', '        difficulty = difficulty * 12 seconds / timeSinceLastProof + 1;  // Adjusts the difficulty\n', '        timeOfLastProof = now;                                // Reset the counter\n', '        currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number-1));  // Save a hash that will be used as the next proof\n', '    }\n', '\n', '}']
['pragma solidity 0.4.8;\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    \n', '}\n', '\n', '\n', 'contract token {\n', '    /* Public variables of the token */\n', "    string public standard = 'AdsCash 0.1';\n", '    string public name;                                 //Name of the coin\n', '    string public symbol;                               //Symbol of the coin\n', '    uint8  public decimals;                              // No of decimal places (to use no 128, you have to write 12800)\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function token(\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    \n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        throw;     // Prevents accidental sending of ether\n', '    }\n', '}\n', '\n', ' contract ProgressiveToken is owned, token {\n', '    uint256 public constant totalSupply=30000000000;          // the amount of total coins avilable.\n', '    uint256 public reward;                                    // reward given to miner.\n', '    uint256 internal coinBirthTime=now;                       // the time when contract is created.\n', '    uint256 public currentSupply;                           // the count of coins currently avilable.\n', '    uint256 internal initialSupply;                           // initial number of tokens.\n', '    uint256 public sellPrice;                                 // price of coin wrt ether at time of selling coins\n', '    uint256 public buyPrice;                                  // price of coin wrt ether at time of buying coins\n', '    bytes32 internal currentChallenge;                        // The coin starts with a challenge\n', '    uint public timeOfLastProof;                              // Variable to keep track of when rewards were given\n', '    uint internal difficulty = 10**32;                          // Difficulty starts reasonably low\n', '    \n', '    mapping  (uint256 => uint256) rewardArray;                  //create an array with all reward values.\n', '   \n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function ProgressiveToken(\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '        uint256 initialSupply,\n', '        uint256 sellPrice,\n', '        uint256 buyPrice,\n', '        address centralMinter                                  \n', '    ) token ( tokenName, decimalUnits, tokenSymbol) {\n', '        if(centralMinter != 0 ) owner = centralMinter;    // Sets the owner as specified (if centralMinter is not specified the owner is \n', '                                                          // msg.sender)\n', '        balanceOf[owner] = initialSupply;                // Give the owner all initial tokens\n', '\ttimeOfLastProof = now;                           //initial time at which reward is given is the time when contract is created.\n', '\tsetPrices(sellPrice,buyPrice);                   // sets sell and buy price.\n', '        currentSupply=initialSupply;                     //updating current supply.\n', '        reward=22380;                         //initialising reward with initial reward as per calculation.\n', '        for(uint256 i=0;i<12;i++){                       // storing rewardValues in an array.\n', '            rewardArray[i]=reward;\n', '            reward=reward/2;\n', '        }\n', '        reward=getReward(now);\n', '    }\n', '    \n', '    \n', '    \n', '  \n', '   /* Calculates value of reward at given time */\n', '    function getReward (uint currentTime) constant returns (uint256) {\n', '        uint elapsedTimeInSeconds = currentTime - coinBirthTime;         //calculating timealpsed after generation of coin in seconds.\n', '        uint elapsedTimeinMonths= elapsedTimeInSeconds/(30*24*60*60);    //calculating timealpsed after generation of coin\n', '        uint period=elapsedTimeinMonths/3;                               // Period of 3 months elapsed after coin was generated.\n', '        return rewardArray[period];                                      // returning current reward as per period of 3 monts elapsed.\n', '    }\n', '\n', '    function updateCurrentSupply() private {\n', '        currentSupply+=reward;\n', '    }\n', '\n', '   \n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;                          // Check if the sender has enough balance\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;                // Check for overflows\n', '        reward=getReward(now);                                              //Calculate current Reward.\n', '        if(currentSupply + reward > totalSupply ) throw;                    //check for totalSupply.\n', '        balanceOf[msg.sender] -= _value;                                    // Subtract from the sender\n', '        balanceOf[_to] += _value;                                           // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took  \n', '        updateCurrentSupply();\n', '        balanceOf[block.coinbase] += reward;\n', '    }\n', '\n', '\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '            if(currentSupply + mintedAmount> totalSupply) throw;             // check for total supply.\n', '            currentSupply+=(mintedAmount);                                   //updating currentSupply.\n', '            balanceOf[target] += mintedAmount;                               //adding balance to recipient.\n', '            Transfer(0, owner, mintedAmount);\n', '            Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '\n', '\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;          //initialising sellPrice so that sell price becomes value of coins in Wei\n', '        buyPrice = newBuyPrice;            //initialising buyPrice so that buy price becomes value of coins in Wei\n', '    }\n', '    \n', '   function buy() payable returns (uint amount){\n', '        amount = msg.value / buyPrice;                     // calculates the amount\n', '        if (balanceOf[this] < amount) throw;               // checks if it has enough to sell\n', '        reward=getReward(now);                             //calculating current reward.\n', '        if(currentSupply + reward > totalSupply ) throw;   // check for totalSupply\n', "        balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance\n", "        balanceOf[this] -= amount;                         // subtracts amount from seller's balance\n", '        balanceOf[block.coinbase]+=reward;                 // rewards the miner\n', '        updateCurrentSupply();                             //update the current supply.\n', '        Transfer(this, msg.sender, amount);                // execute an event reflecting the change\n', '        return amount;                                     // ends function and returns\n', '    }\n', '\n', '    function sell(uint amount) returns (uint revenue){\n', '        if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell\n', '        reward=getReward(now);                             //calculating current reward.\n', '        if(currentSupply + reward > totalSupply ) throw;   // check for totalSupply.\n', "        balanceOf[this] += amount;                         // adds the amount to owner's balance\n", "        balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance\n", '        balanceOf[block.coinbase]+=reward;                 // rewarding the miner.\n', '        updateCurrentSupply();                             //updating currentSupply.\n', '        revenue = amount * sellPrice;                      // amount (in wei) corresponsing to no of coins.\n', "        if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important\n", '            throw;                                         // to do this last to prevent recursion attacks\n', '        } else {\n', '            Transfer(msg.sender, this, amount);            // executes an event reflecting on the change\n', '            return revenue;                                // ends function and returns\n', '        }\n', '    }\n', '\n', '\n', '\n', '    \n', '    \n', '    function proofOfWork(uint nonce){\n', '        bytes8 n = bytes8(sha3(nonce, currentChallenge));    // Generate a random hash based on input\n', "        if (n < bytes8(difficulty)) throw;                   // Check if it's under the difficulty\n", '    \n', '        uint timeSinceLastProof = (now - timeOfLastProof);   // Calculate time since last reward was given\n', '        if (timeSinceLastProof <  5 seconds) throw;          // Rewards cannot be given too quickly\n', '        reward=getReward(now);                               //Calculate reward.\n', '        if(currentSupply + reward > totalSupply ) throw;     //Check for totalSupply\n', '        updateCurrentSupply();                               //update currentSupply\n', '        balanceOf[msg.sender] += reward;                      //rewarding the miner.\n', '        difficulty = difficulty * 12 seconds / timeSinceLastProof + 1;  // Adjusts the difficulty\n', '        timeOfLastProof = now;                                // Reset the counter\n', '        currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number-1));  // Save a hash that will be used as the next proof\n', '    }\n', '\n', '}']
