['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Sample fixed supply token contract\n', '// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20Interface {\n', '    // Get the total token supply\n', '    function totalSupply() public constant returns (uint256);\n', '\n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    // this function is required for some DEX functionality\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract FixedSupplyToken is ERC20Interface {\n', '    string public constant symbol = "FIXED";\n', '    string public constant name = "Example Fixed Supply Token";\n', '    uint8 public constant decimals = 0;\n', '    uint256 _totalSupply = 1000000;\n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    // Functions with this modifier can only be executed by the owner\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    // Constructor\n', '    function FixedSupplyToken() public {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', "    // Transfer the balance from owner's account to another account\n", '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        if (balances[msg.sender] >= _amount\n', '        && _amount > 0\n', '        && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _amount\n', '    ) public returns (bool success) {\n', '        if (balances[_from] >= _amount\n', '        && allowed[_from][msg.sender] >= _amount\n', '        && _amount > 0\n', '        && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Sample fixed supply token contract\n', '// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------------------------\n', '\n', "import './FixedSupplyToken.sol';\n", '\n', 'contract TokenSale {\n', '    \n', '    uint256 fee = 0.01 ether;\n', '    \n', '    uint256 symbolNameIndex;\n', '    \n', '    uint256 historyIndex;\n', '    \n', '    \n', '    //it will divide on 1000\n', '    uint256 siteShareRatio = 1;\n', '    \n', '    address manager;\n', '    \n', '    enum State {Waiting , Selling , Ended , Checkedout}\n', '\n', '    mapping (uint256 => uint) tokenBalanceForAddress;\n', '\n', '    mapping (address => uint256) refAccount;\n', '\n', '    mapping (address => mapping(uint256 => uint)) balanceEthForAddress;\n', '    \n', '    mapping (uint256 => Token) tokens;\n', '\n', '    struct Token {\n', '        address tokenContract;\n', '        address owner;\n', '        string symbolName;\n', '        string symbol;\n', '        string link;\n', '        uint256 amount;\n', '        uint256 leftover;\n', '        uint256 priceInWie;\n', '        uint256 deadline;\n', '        uint decimals;\n', '        State state;\n', '        uint256 referral;\n', '    }\n', '    \n', '    mapping (uint256 => History) histories;\n', '    \n', '    struct History{\n', '        address owner;\n', '        string title;\n', '        uint256 amount;\n', '        uint256 decimals;\n', '        uint256 time;\n', '        string symbol;\n', '    }\n', '    \n', '    event TokenAdded(address erc20TokenAddress);\n', '    event TokenDeposited(address erc20TokenAddress , uint256 amount);\n', '    event DexCheckouted(address erc20TokenAddress , uint256 amount);\n', '    event RefCheckouted(address ownerAddress , uint256 amount);\n', '    event TokenBuyed(address erc20TokenAddress , uint256 amount , address buyer);\n', '\n', '\n', '    function TokenSale() public{\n', '        manager = msg.sender;\n', '    }\n', '\n', '    ///////////////////////\n', '    // TOKEN MANAGEMENT //\n', '    //////////////////////\n', '\n', '    function addToken(address erc20TokenAddress , string symbolName , string symbol , string link , uint256 priceInWie , uint decimals , uint256 referral) public payable {\n', "        require(!hasToken(erc20TokenAddress) , 'Token Is Already Added');\n", "        require(msg.value == fee , 'Add Token Fee Is Invalid');\n", '        require(referral >= 0 && referral <= 100);\n', '        \n', '        manager.transfer(msg.value);\n', '        \n', '        symbolNameIndex++;\n', '        tokens[symbolNameIndex].symbolName = symbolName;\n', '        tokens[symbolNameIndex].tokenContract = erc20TokenAddress;\n', '        tokens[symbolNameIndex].symbol = symbol;\n', '        tokens[symbolNameIndex].link = link;\n', '        tokens[symbolNameIndex].amount = 0;\n', '        tokens[symbolNameIndex].deadline = now;\n', '        tokens[symbolNameIndex].leftover = 0;\n', '        tokens[symbolNameIndex].state = State.Waiting;\n', '        tokens[symbolNameIndex].priceInWie = priceInWie;\n', '        tokens[symbolNameIndex].decimals = decimals;\n', '        tokens[symbolNameIndex].referral = referral;\n', '        tokens[symbolNameIndex].owner = msg.sender;\n', '        \n', "        setHistory(msg.sender , fee , 'Fee For Add Token' , 'ETH' , 18);\n", "        setHistory(manager , fee , '(Manager) Fee For Add Token' , 'ETH' , 18);\n", '        \n', '        TokenAdded(erc20TokenAddress);\n', '\n', '    }\n', '\n', '    function hasToken(address erc20TokenAddress) public constant returns (bool) {\n', '        uint256 index = getSymbolIndexByAddress(erc20TokenAddress);\n', '        if (index == 0) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getSymbolIndexByAddress(address erc20TokenAddress) internal returns (uint256) {\n', '        for (uint256 i = 1; i <= symbolNameIndex; i++) {\n', '            if (tokens[i].tokenContract == erc20TokenAddress) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '    \n', '    function getSymbolIndexByAddressOrThrow(address erc20TokenAddress) returns (uint256) {\n', '        uint256 index = getSymbolIndexByAddress(erc20TokenAddress);\n', '        require(index > 0);\n', '        return index;\n', '    }\n', '    \n', '    function getAllDex() public view returns(address[] memory , string[] memory , uint256[] memory , uint[] memory , uint256[] memory , string[] memory){\n', '        \n', '        address[] memory tokenAdderss = new address[](symbolNameIndex+1);\n', '        string[] memory tokenName = new string[](symbolNameIndex+1);\n', '        string[] memory tokenLink = new string[](symbolNameIndex+1);\n', '        uint256[] memory tokenPrice = new uint256[](symbolNameIndex+1);\n', '        uint[] memory decimal = new uint256[](symbolNameIndex+1);\n', '        uint256[] memory leftover = new uint256[](symbolNameIndex+1);\n', '\n', '\n', '\n', '        for (uint256 i = 0; i <= symbolNameIndex; i++) {\n', '            if(checkDeadLine(tokens[i]) && tokens[i].leftover != 0){\n', '                tokenAdderss[i] = tokens[i].tokenContract;\n', '                tokenName[i] = tokens[i].symbol;\n', '                tokenLink[i] = tokens[i].link;\n', '                tokenPrice[i] = tokens[i].priceInWie;\n', '                decimal[i] = tokens[i].decimals;\n', '                leftover[i] = tokens[i].leftover;\n', '            }\n', '        }\n', '        return (tokenAdderss , tokenName , tokenPrice , decimal , leftover , tokenLink);\n', '    }\n', '\n', '    ////////////////////////////////\n', '    // DEPOSIT / WITHDRAWAL TOKEN //\n', '    ////////////////////////////////\n', '    \n', '    function depositToken(address erc20TokenAddress, uint256 amountTokens , uint256 deadline) public payable {\n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', "        require(tokens[symbolNameIndex].tokenContract != address(0) , 'Token is Invalid');\n", "        require(tokens[symbolNameIndex].state == State.Waiting , 'Token Cannot be deposited');\n", "        require(tokens[symbolNameIndex].owner == msg.sender , 'You are not owner of this coin');\n", '\n', '        ERC20Interface token = ERC20Interface(tokens[symbolNameIndex].tokenContract);\n', '        \n', '        require(token.transferFrom(msg.sender, address(this), amountTokens) == true);\n', '        \n', '        tokens[symbolNameIndex].amount = amountTokens;\n', '        tokens[symbolNameIndex].leftover = amountTokens;\n', '        \n', '        require(tokenBalanceForAddress[symbolNameIndex] + amountTokens >= tokenBalanceForAddress[symbolNameIndex]);\n', '        tokenBalanceForAddress[symbolNameIndex] += amountTokens;\n', '        tokens[symbolNameIndex].state = State.Selling;\n', '        tokens[symbolNameIndex].deadline = deadline;\n', '        \n', '        Token tokenRes = tokens[symbolNameIndex];\n', '        \n', "        setHistory(msg.sender , amountTokens , 'Deposit Token' , tokenRes.symbol , tokenRes.decimals);\n", '        \n', '        TokenDeposited(erc20TokenAddress , amountTokens);\n', '        \n', '    }\n', '\n', '    function checkoutDex(address erc20TokenAddress) public payable {\n', '        \n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', '        \n', '        ERC20Interface token = ERC20Interface(tokens[symbolNameIndex].tokenContract);\n', '\n', '        uint256 _amountTokens = tokens[symbolNameIndex].leftover;\n', '        \n', "        require(tokens[symbolNameIndex].tokenContract != address(0), 'Token is Invalid');\n", "        require(tokens[symbolNameIndex].owner == msg.sender , 'You are not owner of this coin');\n", "        require(!checkDeadLine(tokens[symbolNameIndex]) || tokens[symbolNameIndex].leftover == 0 , 'Token Cannot be withdrawn');\n", '\n', '\n', '        require(tokenBalanceForAddress[symbolNameIndex] - _amountTokens >= 0 , "overflow error");\n', '        require(tokenBalanceForAddress[symbolNameIndex] - _amountTokens <= tokenBalanceForAddress[symbolNameIndex] , "Insufficient amount of token");\n', '        \n', '        tokenBalanceForAddress[symbolNameIndex] -= _amountTokens;\n', '        tokens[symbolNameIndex].leftover = 0;\n', '        tokens[symbolNameIndex].state = State.Checkedout;\n', '        \n', '        if(_amountTokens > 0){\n', '            require(token.transfer(msg.sender, _amountTokens) == true , "transfer failed"); \n', "            setHistory(msg.sender , _amountTokens , 'Check Out Token' , tokens[symbolNameIndex].symbol , tokens[symbolNameIndex].decimals);\n", '        }\n', '\n', '        uint256 _siteShare = balanceEthForAddress[msg.sender][symbolNameIndex] * siteShareRatio / 1000;\n', '        uint256 _ownerShare = balanceEthForAddress[msg.sender][symbolNameIndex] - _siteShare;\n', '        \n', "        setHistory(msg.sender , _ownerShare , 'Check Out ETH' , 'ETH' , 18 );\n", "        setHistory(manager , _siteShare , '(Manager) Site Share For Deposite Token' , 'ETH' , 18);\n", '\n', '        \n', '        msg.sender.transfer(_ownerShare);\n', '        \n', '        DexCheckouted(erc20TokenAddress , _ownerShare);\n', '\n', '    }\n', '\n', '    function getBalance(address erc20TokenAddress) public constant returns (uint256) {\n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', '        return tokenBalanceForAddress[symbolNameIndex];\n', '    }\n', '    \n', '    function checkoutRef(uint256 amount) public payable {\n', '        \n', '        amount = amount;\n', '        \n', "        require(refAccount[msg.sender] >= amount , 'Insufficient amount of ETH');\n", '\n', '        refAccount[msg.sender] -= amount;\n', '        \n', "        setHistory(msg.sender , amount , 'Check Out Referral' , 'ETH' , 18 );\n", '\n', '        msg.sender.transfer(amount);\n', '        \n', '        RefCheckouted(msg.sender , amount);\n', '    }\n', '    \n', '    function getRefBalance(address _ownerAddress) view returns(uint256){\n', '        return refAccount[_ownerAddress];\n', '    }\n', '\n', '    \n', '    ///////////////\n', '    // Buy Token //\n', '    ///////////////\n', '    \n', '    function buyToken(address erc20TokenAddress , address refAddress , uint256 _amount) payable returns(bool){\n', '        \n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', '        Token token = tokens[symbolNameIndex];\n', '\n', "        require(token.state == State.Selling , 'You Can not Buy This Token');\n", '        require((_amount * token.priceInWie) / (10 ** token.decimals)  == msg.value , "Incorrect Eth Amount");\n', "        require(checkDeadLine(token) , 'Deadline Passed');\n", "        require(token.leftover >= _amount , 'Insufficient Token Amount');\n", '        \n', '        if(erc20TokenAddress != refAddress){\n', '            uint256 ref = msg.value * token.referral / 100;\n', '            balanceEthForAddress[token.owner][symbolNameIndex] += msg.value - ref;\n', '            refAccount[refAddress] += ref;\n', '        }else{\n', '            balanceEthForAddress[token.owner][symbolNameIndex] += msg.value;\n', '        }    \n', '        \n', '        ERC20Interface ERC20token = ERC20Interface(tokens[symbolNameIndex].tokenContract);\n', '        \n', '        \n', '        ERC20token.approve(address(this) , _amount);\n', '\n', "        require(ERC20token.transferFrom(address(this) , msg.sender , _amount) == true , 'Insufficient Token Amount');\n", '        \n', "        setHistory(msg.sender , _amount , 'Buy Token' , token.symbol , token.decimals);\n", '\n', '        \n', '        token.leftover -= _amount;\n', '        tokenBalanceForAddress[symbolNameIndex] -= _amount;\n', '        \n', '        if(token.leftover == 0){\n', '            token.state = State.Ended;\n', '        }\n', '        \n', '        TokenBuyed(erc20TokenAddress , _amount , msg.sender);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function leftover(address erc20TokenAddress , uint256 _amount) public view returns(uint256){\n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', '        return tokens[symbolNameIndex].leftover;\n', '    }\n', '    \n', '    function checkDeadLine(Token token) internal returns(bool){\n', '        return (now < token.deadline); \n', '    }\n', '    \n', '    function getOwnerTokens(address owner) public view returns(address[] memory , string[] memory , uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory , uint[] memory ){\n', '        \n', '        address[] memory tokenAdderss = new address[](symbolNameIndex+1);\n', '        string[] memory tokenName = new string[](symbolNameIndex+1);\n', '        uint256[] memory tokenAmount = new uint256[](symbolNameIndex+1);\n', '        uint256[] memory tokenLeftover = new uint256[](symbolNameIndex+1);\n', '        uint256[] memory tokenPrice = new uint256[](symbolNameIndex+1);\n', '        uint256[] memory tokenDeadline = new uint256[](symbolNameIndex+1);\n', '        uint[] memory status = new uint[](symbolNameIndex+1);\n', '\n', '\n', '        for (uint256 i = 0; i <= symbolNameIndex; i++) {\n', '            if (tokens[i].owner == owner) {\n', '                tokenAdderss[i] = tokens[i].tokenContract;\n', '                tokenName[i] = tokens[i].symbol;\n', '                tokenAmount[i] = tokens[i].amount;\n', '                tokenLeftover[i] = tokens[i].leftover;\n', '                tokenPrice[i] = tokens[i].priceInWie;\n', '                tokenDeadline[i] = tokens[i].deadline;\n', '\n', '                if(tokens[i].state == State.Waiting)\n', '                    status[i] = 1;\n', '                else{    \n', '                    if(tokens[i].state == State.Selling)\n', '                        status[i] = 2;\n', '                    if(!checkDeadLine(tokens[i]) || tokens[i].leftover == 0)\n', '                        status[i] = 3;\n', '                    if(tokens[i].state == State.Checkedout)\n', '                        status[i] = 4;\n', '                }\n', '            }\n', '        }\n', '        return (tokenAdderss , tokenName , tokenLeftover , tokenAmount , tokenPrice , tokenDeadline , status);\n', '    }\n', '    \n', '    function getDecimal(address erc20TokenAddress) public view returns(uint256){\n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', '        return tokens[symbolNameIndex].decimals;\n', '    }\n', '    \n', '    function getOwnerTokenDetails(address erc20TokenAddress) public view returns(Token){\n', '        uint256 symbolNameIndex = getSymbolIndexByAddressOrThrow(erc20TokenAddress);\n', '        Token token = tokens[symbolNameIndex];\n', '        require(token.owner == msg.sender);\n', '        \n', '        return token;\n', '    }\n', '    \n', '    function setHistory(address _owner , uint256 _amount , string _name , string _symbol , uint256 _decimals) public {\n', '        histories[historyIndex].amount = _amount;\n', '        histories[historyIndex].title = _name;\n', '        histories[historyIndex].owner = _owner;\n', '        histories[historyIndex].symbol = _symbol;\n', '        histories[historyIndex].time = now;\n', '        histories[historyIndex].decimals = _decimals;\n', '        \n', '        historyIndex++;\n', '    }\n', '    \n', '    function getHistory(address _owner) public view returns(string[] , string[] , uint256[] , uint256[] , uint256[]){\n', '        \n', '        string[] memory title = new string[](historyIndex+1);\n', '        string[] memory symbol = new string[](historyIndex+1);\n', '        uint256[] memory time = new uint256[](historyIndex+1);\n', '        uint256[] memory amount = new uint256[](historyIndex+1);\n', '        uint256[] memory decimals = new uint256[](historyIndex+1);\n', '\n', '\n', '\n', '        for (uint256 i = 0; i <= historyIndex; i++) {\n', '            if (histories[i].owner == _owner) {\n', '                title[i] = histories[i].title;\n', '                symbol[i] = histories[i].symbol;\n', '                time[i] = histories[i].time;\n', '                amount[i] = histories[i].amount;\n', '                decimals[i] = histories[i].decimals;\n', '            }\n', '        }\n', '        return (title , symbol , time , amount , decimals);\n', '    }\n', '}']
