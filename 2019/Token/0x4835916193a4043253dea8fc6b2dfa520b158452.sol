['pragma solidity 0.5.3;\n', '// ----------------------------------------------------------------------------\n', "// 'MICA' contract\n", '//\n', '// Deployed to :0x7f1637fAcaCe03069D3cf1C29015a353B89243f8\n', '// Symbol      : MICA\n', '// Name        : MICATOKEN\n', '// Total supply: 65,000,000,000\n', '// Decimals    : 18\n', '//\n', '\n', '// ----------------------------------------------------------------------------\n', '   \n', '    /**\n', '     * @title SafeMath\n', '     * @dev Math operations with safety checks that throw on error\n', '     */\n', '    library SafeMath {\n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '      }\n', '    \n', '      function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '      }\n', '    \n', '      function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '      }\n', '    \n', '      function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '      }\n', '    }\n', '    \n', '    contract owned {\n', '        address payable public owner;\n', '    \tusing SafeMath for uint256;\n', '    \t\n', '        constructor() public {\n', '            owner = msg.sender;\n', '        }\n', '    \n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '    \n', '        function transferOwnership(address payable newOwner) onlyOwner public {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external ; }\n', '    \n', '    contract TokenERC20 {\n', '        // Public variables of the token\n', '        using SafeMath for uint256;\n', '    \tstring public name = "MICATOKEN";\n', '        string public symbol = "MICA";\n', '        uint8 public decimals = 18;         // 18 decimals is the strongly suggested default, avoid changing it\n', '        uint256 public totalSupply          = 65000000000 * (1 ether);   \n', '        uint256 public tokensForCrowdsale   = 50000000000 * (1 ether);\n', '        uint256 public tokensForTeam        = 5000000000  * (1 ether);\n', '        uint256 public tokensForOwner       = 10000000000  * (1 ether);\n', '        \n', '\t\taddress public teamWallet = 0x7f1637fAcaCe03069D3cf1C29015a353B89243f8;\n', '    \n', '        // This creates an array with all balances\n', '        mapping (address => uint256) public balanceOf;\n', '        mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '        // This generates a public event on the blockchain that will notify clients\n', '        event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '        // This notifies clients about the amount burnt\n', '        event Burn(address indexed from, uint256 value);\n', '    \n', '        /**\n', '         * Constrctor function\n', '         *\n', '         * Initializes contract with initial supply tokens to the creator of the contract\n', '         */\n', '        constructor() public {\n', '\t\t\t \n', '            balanceOf[address(this)] = tokensForCrowdsale;          // 50 Billion will remain in contract for crowdsale\n', '            balanceOf[teamWallet] = tokensForTeam;         // 5 Billion will be allocated to Team\n', '            balanceOf[msg.sender] = tokensForOwner;        // 10 Billon will be sent to contract owner\n', '\n', '            //emiiting events for loggin purpose\n', '            emit Transfer(address(0), address(this), tokensForCrowdsale);\n', '            emit Transfer(address(0), teamWallet, tokensForTeam);\n', '            emit Transfer(address(0), address(msg.sender), tokensForOwner);\n', '        }\n', '    \n', '        /**\n', '         * Internal transfer, only can be called by this contract\n', '         */\n', '        function _transfer(address _from, address _to, uint _value) internal {\n', '            // Prevent transfer to 0x0 address. Use burn() instead\n', '            require(_to != address(0x0));\n', '            // Check if the sender has enough\n', '            require(balanceOf[_from] >= _value);\n', '            // Check for overflows\n', '            require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '            // Save this for an assertion in the future\n', '            uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '            // Subtract from the sender\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);\n', '            // Add the same to the recipient\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '            assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '        }\n', '    \n', '        /**\n', '         * Transfer tokens\n', '         *\n', '         * Send `_value` tokens to `_to` from your account\n', '         *\n', '         * @param _to The address of the recipient\n', '         * @param _value the amount to send\n', '         */\n', '        function transfer(address _to, uint256 _value) public {\n', '            _transfer(msg.sender, _to, _value);\n', '        }\n', '    \n', '        /**\n', '         * Transfer tokens from other address\n', '         *\n', '         * Send `_value` tokens to `_to` in behalf of `_from`\n', '         *\n', '         * @param _from The address of the sender\n', '         * @param _to The address of the recipient\n', '         * @param _value the amount to send\n', '         */\n', '        function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '            require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '            _transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Set allowance for other address\n', '         *\n', '         * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '         *\n', '         * @param _spender The address authorized to spend\n', '         * @param _value the max amount they can spend\n', '         */\n', '        function approve(address _spender, uint256 _value) public\n', '            returns (bool success) {\n', '            allowance[msg.sender][_spender] = _value;\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Set allowance for other address and notify\n', '         *\n', '         * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '         *\n', '         * @param _spender The address authorized to spend\n', '         * @param _value the max amount they can spend\n', '         * @param _extraData some extra information to send to the approved contract\n', '         */\n', '        function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)\n', '            public\n', '            returns (bool success) {\n', '            tokenRecipient spender = tokenRecipient(_spender);\n', '            if (approve(_spender, _value)) {\n', '                spender.receiveApproval(msg.sender, _value, address(this), _extraData);\n', '                return true;\n', '            }\n', '        }\n', '    \n', '        /**\n', '         * Destroy tokens\n', '         *\n', '         * Remove `_value` tokens from the system irreversibly\n', '         *\n', '         * @param _value the amount of money to burn\n', '         */\n', '        function burn(uint256 _value) public returns (bool success) {\n', '            require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '            totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '           emit Burn(msg.sender, _value);\n', '            return true;\n', '        }\n', '    \n', '        /**\n', '         * Destroy tokens from other account\n', '         *\n', '         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '         *\n', '         * @param _from the address of the sender\n', '         * @param _value the amount of money to burn\n', '         */\n', '        function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '            require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '            require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', "            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '            totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '          emit  Burn(_from, _value);\n', '            return true;\n', '        }\n', '    }\n', '    \n', '    /******************************************/\n', '    /*       ADVANCED TOKEN STARTS HERE       */\n', '    /******************************************/\n', '    \n', '    contract MICATOKEN is owned, TokenERC20 {\n', '\n', '    \tusing SafeMath for uint256;\n', '    \tuint256 public startTime = 0; //client wants ICO run Infinite time, so startTimeStamp 0\n', '    \tuint256 public endTime = 9999999999999999999999; //and entTimeStamp higher number\n', '\t\tuint256 public exchangeRate = 50000000; // this is how many tokens for 1 Ether\n', '\t\tuint256 public tokensSold = 0; // how many tokens sold in crowdsale\n', '\t\t\n', '        mapping (address => bool) public frozenAccount;\n', '    \n', '        /* This generates a public event on the blockchain that will notify clients */\n', '        event FrozenFunds(address target, bool frozen);\n', '    \n', '        /* Initializes contract with initial supply tokens to the creator of the contract */\n', '        constructor() TokenERC20() public {}\n', '\n', '        /* Internal transfer, only can be called by this contract */\n', '        function _transfer(address _from, address _to, uint _value) internal {\n', '            require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead\n', '            require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '            require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '            //overflow and undeflow is secured by SafeMath library\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender\n', '            balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient\n', '            emit Transfer(_from, _to, _value);\n', '        }\n', '        \n', '        //@dev fallback function, only accepts ether if ICO is running or Reject\n', '        function () payable external {\n', "            require(endTime > now && startTime < now, 'ICO is not running');\n", '            uint256 ethervalueWEI=msg.value;\n', '            // calculate token amount to be sent\n', '            uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price\n', '            tokensSold = tokensSold.add(token);\n', '            _transfer(address(this), msg.sender, token);     // makes the transfers\n', '            forwardEherToOwner();\n', '        }\n', '        \n', '        //Automatocally forwards ether from smart contract to owner address\n', '        function forwardEherToOwner() internal {\n', '            owner.transfer(msg.value); \n', '          }\n', '        \n', '        //function to start an ICO.\n', '        //It requires: start and end timestamp, exchange rate in Wei, and token amounts to allocate for the ICO\n', '\t\t//It will transfer allocated amount to the smart contract\n', '\t\tfunction startIco(uint256 start_,uint256 end_, uint256 exchangeRateInWei, uint256 TokensAllocationForICO) onlyOwner public {\n', '\t\t\trequire(start_ < end_);\n', '\t\t\tuint256 tokenAmount = TokensAllocationForICO.mul(1 ether);\n', '\t\t\trequire(balanceOf[msg.sender] > tokenAmount);\n', '\t\t\tstartTime=start_;\n', '\t\t\tendTime=end_;\n', '\t\t\texchangeRate = exchangeRateInWei;\n', '\t\t\ttransfer(address(this),tokenAmount);\n', '        }    \t\n', '        \n', '        //Stops an ICO.\n', '        //It will also transfer remaining tokens to owner\n', '\t\tfunction stopICO() onlyOwner public{\n', '            endTime = 0;\n', '            uint256 tokenAmount=balanceOf[address(this)];\n', '            _transfer(address(this), msg.sender, tokenAmount);\n', '        }\n', '        \n', '        //function to check wheter ICO is running or not.\n', '        function isICORunning() public view returns(bool){\n', '            if(endTime > now && startTime < now){\n', '                return true;                \n', '            }else{\n', '                return false;\n', '            }\n', '        }\n', '        \n', '        //Function to set ICO Exchange rate. \n', '    \tfunction setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {\n', '\t\t\texchangeRate=newExchangeRate;\n', '        }\n', '        \n', '        //Just in case, owner wants to transfer Tokens from contract to owner address\n', '        function manualWithdrawToken(uint256 _amount) onlyOwner public {\n', '            uint256 tokenAmount = _amount.mul(1 ether);\n', '            _transfer(address(this), msg.sender, tokenAmount);\n', '          }\n', '          \n', '        //Just in case, owner wants to transfer Ether from contract to owner address\n', '        function manualWithdrawEther()onlyOwner public{\n', '\t\t\tuint256 amount=address(this).balance;\n', '\t\t\towner.transfer(amount);\n', '\t\t}\n', '\t\t\n', '        /// @notice Create `mintedAmount` tokens and send it to `target`\n', '        /// @param target Address to receive the tokens\n', '        /// @param mintedAmount the amount of tokens it will receive\n', '        function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '            balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '            totalSupply = totalSupply.add(mintedAmount);\n', '           emit Transfer(address(0), address(this), mintedAmount);\n', '           emit Transfer(address(this), target, mintedAmount);\n', '        }\n', '    \n', '        /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '        /// @param target Address to be frozen\n', '        /// @param freeze either to freeze it or not\n', '        function freezeAccount(address target, bool freeze) onlyOwner public {\n', '            frozenAccount[target] = freeze;\n', '          emit  FrozenFunds(target, freeze);\n', '        }\n', '\n', '\n', '\n', '    }']