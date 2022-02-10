['pragma solidity 0.4.25; /*\n', '\n', '___________________________________________________________________\n', '  _      _                                        ______           \n', '  |  |  /          /                                /              \n', '--|-/|-/-----__---/----__----__---_--_----__-------/-------__------\n', "  |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     \n", '__/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_\n', '\n', '\n', '███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗      ██████╗ ██████╗ ██╗███╗   ██╗\n', '██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝     ██╔════╝██╔═══██╗██║████╗  ██║\n', '███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗    ██║     ██║   ██║██║██╔██╗ ██║\n', '╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║    ██║     ██║   ██║██║██║╚██╗██║\n', '███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝    ╚██████╗╚██████╔╝██║██║ ╚████║\n', '╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝\n', '                                                                                     \n', '\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'Storag Coin' contract with following features\n", '//      => In-built ICO functionality - receive tokens when sent ether to contract address\n', '//      => ERC20 Compliance\n', '//      => Higher control of ICO by owner\n', '//      => selfdestruct functionality\n', '//      => SafeMath implementation \n', '//      => User whitelisting\n', '//      => Minting new tokens by owner\n', '//\n', '// Name        : Storag Coin\n', '// Symbol      : STG\n', '// Decimals    : 8\n', '// Total supply: 1,000,000,000  (1 Billion)\n', '//\n', '// Copyright (c) 2018 Storag Coin Inc. The MIT Licence.\n', '// Contract designed by EtherAuthority ( https://EtherAuthority.io )\n', '// ----------------------------------------------------------------------------\n', '  \n', '*/ \n', '\n', '//*******************************************************************//\n', '//------------------------ SafeMath Library -------------------------//\n', '//*******************************************************************//\n', '    /**\n', '     * @title SafeMath\n', '     * @dev Math operations with safety checks that throw on error\n', '     */\n', '    library SafeMath {\n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '      }\n', '    \n', '      function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '      }\n', '    \n', '      function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '      }\n', '    \n', '      function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '      }\n', '    }\n', '\n', '\n', '//*******************************************************************//\n', '//------------------ Contract to Manage Ownership -------------------//\n', '//*******************************************************************//\n', '    \n', '    contract owned {\n', '        address public owner;\n', '        \n', '         constructor () public {\n', '            owner = msg.sender;\n', '        }\n', '    \n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '    \n', '        function transferOwnership(address newOwner) onlyOwner public {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '\n', '//***************************************************************//\n', '//------------------ ERC20 Standard Template -------------------//\n', '//***************************************************************//\n', '    \n', '    contract TokenERC20 {\n', '        // Public variables of the token\n', '        using SafeMath for uint256;\n', '        string public name;\n', '        string public symbol;\n', '        uint256 public decimals = 8; \n', '        uint256 public totalSupply;\n', '        uint256 public reservedForICO;\n', '        bool public safeguard = false;  //putting safeguard on will halt all non-owner functions\n', '    \n', '        // This creates an array with all balances\n', '        mapping (address => uint256) public balanceOf;\n', '        mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '        // This generates a public event on the blockchain that will notify clients\n', '        event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '        // This notifies clients about the amount burnt\n', '        event Burn(address indexed from, uint256 value);\n', '    \n', '        /**\n', '         * Constrctor function\n', '         *\n', '         * Initializes contract with initial supply tokens to the creator of the contract\n', '         */\n', '        constructor (\n', '            uint256 initialSupply,\n', '            uint256 allocatedForICO,\n', '            string tokenName,\n', '            string tokenSymbol\n', '        ) public {\n', '            totalSupply = initialSupply.mul(1e8);       // Update total supply with the decimal amount\n', '            reservedForICO = allocatedForICO.mul(1e8);  // Tokens reserved For ICO\n', '            balanceOf[this] = reservedForICO;           // 250 Million Tokens will remain in the contract\n', '            balanceOf[msg.sender]=totalSupply.sub(reservedForICO); // Rest of tokens will be sent to owner\n', '            name = tokenName;                           // Set the name for display purposes\n', '            symbol = tokenSymbol;                       // Set the symbol for display purposes\n', '        }\n', '    \n', '        /**\n', '         * Internal transfer, only can be called by this contract\n', '         */\n', '        function _transfer(address _from, address _to, uint _value) internal {\n', '            require(!safeguard);\n', '            // Prevent transfer to 0x0 address. Use burn() instead\n', '            require(_to != 0x0);\n', '            // Check if the sender has enough\n', '            require(balanceOf[_from] >= _value);\n', '            // Check for overflows\n', '            require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '            // Save this for an assertion in the future\n', '            uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '            // Subtract from the sender\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);\n', '            // Add the same to the recipient\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '            assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '        }\n', '    \n', '        /**\n', '         * Transfer tokens\n', '         *\n', '         * Send `_value` tokens to `_to` from your account\n', '         *\n', '         * @param _to The address of the recipient\n', '         * @param _value the amount to send\n', '         */\n', '        function transfer(address _to, uint256 _value) public returns (bool success) {\n', '            _transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Transfer tokens from other address\n', '         *\n', '         * Send `_value` tokens to `_to` in behalf of `_from`\n', '         *\n', '         * @param _from The address of the sender\n', '         * @param _to The address of the recipient\n', '         * @param _value the amount to send\n', '         */\n', '        function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '            require(!safeguard);\n', '            require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '            _transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Set allowance for other address\n', '         *\n', '         * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '         *\n', '         * @param _spender The address authorized to spend\n', '         * @param _value the max amount they can spend\n', '         */\n', '        function approve(address _spender, uint256 _value) public\n', '            returns (bool success) {\n', '            require(!safeguard);\n', '            allowance[msg.sender][_spender] = _value;\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Set allowance for other address and notify\n', '         *\n', '         * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '         *\n', '         * @param _spender The address authorized to spend\n', '         * @param _value the max amount they can spend\n', '         * @param _extraData some extra information to send to the approved contract\n', '         */\n', '        function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '            public\n', '            returns (bool success) {\n', '            require(!safeguard);\n', '            tokenRecipient spender = tokenRecipient(_spender);\n', '            if (approve(_spender, _value)) {\n', '                spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '                return true;\n', '            }\n', '        }\n', '    \n', '        /**\n', '         * Destroy tokens\n', '         *\n', '         * Remove `_value` tokens from the system irreversibly\n', '         *\n', '         * @param _value the amount of money to burn\n', '         */\n', '        function burn(uint256 _value) public returns (bool success) {\n', '            require(!safeguard);\n', '            require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '            totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '            emit Burn(msg.sender, _value);\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Destroy tokens from other account\n', '         *\n', '         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '         *\n', '         * @param _from the address of the sender\n', '         * @param _value the amount of money to burn\n', '         */\n', '        function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '            require(!safeguard);\n', '            require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '            require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', "            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '            totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '            emit  Burn(_from, _value);\n', '            return true;\n', '        }\n', '        \n', '    }\n', '    \n', '//******************************************************************************//\n', '//---------------------  STORAG COIN MAIN CODE STARTS HERE --------------------//\n', '//******************************************************************************//\n', '    \n', '    contract StoragCoin is owned, TokenERC20 {\n', '        \n', '        /*************************************/\n', '        /*  User whitelisting functionality  */\n', '        /*************************************/\n', '        bool public whitelistingStatus = false;\n', '        mapping (address => bool) public whitelisted;\n', '        \n', '        /**\n', '         * Change whitelisting status on or off\n', '         *\n', '         * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.\n', '         */\n', '        function changeWhitelistingStatus() onlyOwner public{\n', '            if (whitelistingStatus == false){\n', '                whitelistingStatus = true;\n', '            }\n', '            else{\n', '                whitelistingStatus = false;    \n', '            }\n', '        }\n', '        \n', '        /**\n', '         * Whitelist any user address - only Owner can do this\n', '         *\n', '         * It will add user address in whitelisted mapping\n', '         */\n', '        function whitelistUser(address userAddress) onlyOwner public{\n', '            require(whitelistingStatus == true);\n', '            require(userAddress != 0x0);\n', '            whitelisted[userAddress] = true;\n', '        }\n', '        \n', '        /**\n', '         * Whitelist Many user address at once - only Owner can do this\n', '         * It will require maximum of 150 addresses to prevent block gas limit max-out and DoS attack\n', '         * It will add user address in whitelisted mapping\n', '         */\n', '        function whitelistManyUsers(address[] userAddresses) onlyOwner public{\n', '            require(whitelistingStatus == true);\n', '            uint256 addressCount = userAddresses.length;\n', '            require(addressCount <= 150);\n', '            for(uint256 i = 0; i < addressCount; i++){\n', '                require(userAddresses[i] != 0x0);\n', '                whitelisted[userAddresses[i]] = true;\n', '            }\n', '        }\n', '        \n', '        \n', '        \n', '        /********************************/\n', '        /* Code for the ERC20 STG Token */\n', '        /********************************/\n', '    \n', '        /* Public variables of the token */\n', '        string private tokenName = "Storag Coin";\n', '        string private tokenSymbol = "STG";\n', '        uint256 private initialSupply = 1000000000;     // 1 Billion\n', '        uint256 private allocatedForICO = 250000000;    // 250 Million\n', '        \n', '        \n', '        /* Records for the fronzen accounts */\n', '        mapping (address => bool) public frozenAccount;\n', '        \n', '        /* This generates a public event on the blockchain that will notify clients */\n', '        event FrozenFunds(address target, bool frozen);\n', '    \n', '        /* Initializes contract with initial supply tokens to the creator of the contract */\n', '        constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public {}\n', '\n', '        /* Internal transfer, only can be called by this contract */\n', '        function _transfer(address _from, address _to, uint _value) internal {\n', '            require(!safeguard);\n', '            require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '            require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '            require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows\n', '            require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '            require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender\n', '            balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient\n', '            emit Transfer(_from, _to, _value);\n', '        }\n', '        \n', '        /// @notice Create `mintedAmount` tokens and send it to `target`\n', '        /// @param target Address to receive the tokens\n', '        /// @param mintedAmount the amount of tokens it will receive\n', '        function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '            balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '            totalSupply = totalSupply.add(mintedAmount);\n', '            emit Transfer(0, this, mintedAmount);\n', '            emit Transfer(this, target, mintedAmount);\n', '        }\n', '\n', '        /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '        /// @param target Address to be frozen\n', '        /// @param freeze either to freeze it or not\n', '        function freezeAccount(address target, bool freeze) onlyOwner public {\n', '                frozenAccount[target] = freeze;\n', '            emit  FrozenFunds(target, freeze);\n', '        }\n', '\n', '        \n', '        //public variables for the Crowdsale\n', '        uint256 public exchangeRate = 9672;            // 1 ETH = 9672 Tokens \n', '        uint256 public tokensSold = 0;                  // how many tokens sold through crowdsale\n', '        \n', '        //@dev fallback function, only accepts ether if pre-sale or ICO is running or Reject\n', '        function () payable external {\n', '            require(!safeguard);\n', '            require(!frozenAccount[msg.sender]);\n', '            if(whitelistingStatus == true) { require(whitelisted[msg.sender]); }\n', '            // calculate token amount to be sent\n', '            uint256 finalTokens = msg.value.mul(exchangeRate).div(1e10);        //weiamount * exchangeRate\n', '            tokensSold = tokensSold.add(finalTokens);\n', '            _transfer(this, msg.sender, finalTokens);                           //makes the transfers\n', '            forwardEherToOwner();                                               //send Ether to owner\n', '        }\n', '\n', '        //Automatocally forwards ether from smart contract to owner address\n', '        function forwardEherToOwner() internal {\n', '            address(owner).transfer(msg.value); \n', '        }\n', '        \n', '        //Function to set ICO Exchange rate. \n', '        //1 ETH = How many Tokens ?\n', '        function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {\n', '            exchangeRate=newExchangeRate;\n', '        }\n', '        \n', '        //Just in case, owner wants to transfer Tokens from contract to owner address\n', '        function manualWithdrawToken(uint256 _amount) onlyOwner public {\n', '            uint256 tokenAmount = _amount.mul(1e8);\n', '            _transfer(this, msg.sender, tokenAmount);\n', '        }\n', '          \n', '        //Just in case, owner wants to transfer Ether from contract to owner address\n', '        function manualWithdrawEther()onlyOwner public{\n', '            uint256 amount=address(this).balance;\n', '            address(owner).transfer(amount);\n', '        }\n', '        \n', '        //selfdestruct function. just in case owner decided to destruct this contract.\n', '        function destructContract()onlyOwner public{\n', '            selfdestruct(owner);\n', '        }\n', '        \n', '        /**\n', '         * Change safeguard status on or off\n', '         *\n', '         * When safeguard is true, then all the non-owner functions will stop working.\n', '         * When safeguard is false, then all the functions will resume working back again!\n', '         */\n', '        function changeSafeguardStatus() onlyOwner public{\n', '            if (safeguard == false){\n', '                safeguard = true;\n', '            }\n', '            else{\n', '                safeguard = false;    \n', '            }\n', '        }\n', '        \n', '}']