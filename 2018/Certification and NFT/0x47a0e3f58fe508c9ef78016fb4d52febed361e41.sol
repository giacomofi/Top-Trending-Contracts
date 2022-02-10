['pragma solidity ^0.4.17;\n', '\n', 'library SafeMathMod { // Partial SafeMath Library\n', '\n', '    function mul(uint256 a, uint256 b) constant internal returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) constant internal returns(uint256) {\n', '        assert(b != 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        require((c = a - b) < a);\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        require((c = a + b) > a);\n', '    }\n', '}\n', '\n', 'contract Usdcoins { //is inherently ERC20\n', '    using SafeMathMod\n', '    for uint256;\n', '\n', '    /**\n', '     * @constant name The name of the token\n', '     * @constant symbol  The symbol used to display the currency\n', '     * @constant decimals  The number of decimals used to dispay a balance\n', '     * @constant totalSupply The total number of tokens times 10^ of the number of decimals\n', '     * @constant MAX_UINT256 Magic number for unlimited allowance\n', '     * @storage balanceOf Holds the balances of all token holders\n', '     * @storage allowed Holds the allowable balance to be transferable by another address.\n', '     */\n', '\n', '    address owner;\n', '\n', '\n', '\n', '    string constant public name = "USDC";\n', '\n', '    string constant public symbol = "USDC";\n', '\n', '    uint256 constant public decimals = 18;\n', '\n', '    uint256 constant public totalSupply = 100000000e18;\n', '\n', '    uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    mapping(address => mapping(address => uint256)) public allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function() payable {\n', '        revert();\n', '    }\n', '\n', '    function Usdcoins() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '\n', '    /**\n', '     * @dev function that sells available tokens\n', '     */\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool success) {\n', '        /* Ensures that tokens are not sent to address "0x0" */\n', '        require(_to != address(0));\n', '        /* Prevents sending tokens directly to contracts. */\n', '\n', '\n', '        /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {\n', '        /* Ensures that tokens are not sent to address "0x0" */\n', '        require(_to != address(0));\n', '        /* Ensures tokens are not sent to this contract */\n', '\n', '\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/\n', '        require(_value <= allowance || _from == msg.sender);\n', '\n', '        /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '\n', '        /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */\n', '        /* Balance holder does not need allowance to send from self. */\n', '        if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amounts of tokens to the specified addresses.\n', '     * @dev Be aware that there is no check for duplicate recipients.\n', '     *\n', '     * @param _toAddresses Receiver addresses.\n', '     * @param _amounts Amounts of tokens that will be transferred.\n', '     */\n', '    function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {\n', '        /* Ensures _toAddresses array is less than or equal to 255 */\n', '        require(_toAddresses.length <= 255);\n', '        /* Ensures _toAddress and _amounts have the same number of entries. */\n', '        require(_toAddresses.length == _amounts.length);\n', '\n', '        for (uint8 i = 0; i < _toAddresses.length; i++) {\n', '            transfer(_toAddresses[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.\n', '     * @dev Be aware that there is no check for duplicate recipients.\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _toAddresses The addresses of the recipients (MAX 255)\n', '     * @param _amounts The amounts of tokens to be transferred\n', '     */\n', '    function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {\n', '        /* Ensures _toAddresses array is less than or equal to 255 */\n', '        require(_toAddresses.length <= 255);\n', '        /* Ensures _toAddress and _amounts have the same number of entries. */\n', '        require(_toAddresses.length == _amounts.length);\n', '\n', '        for (uint8 i = 0; i < _toAddresses.length; i++) {\n', '            transferFrom(_from, _toAddresses[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '     *\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool success) {\n', '        /* Ensures address "0x0" is not assigned allowance. */\n', '        require(_spender != address(0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns(uint256 remaining) {\n', '        remaining = allowed[_owner][_spender];\n', '    }\n', '\n', '    function isNotContract(address _addr) private view returns(bool) {\n', '        uint length;\n', '        assembly {\n', '            /* retrieve the size of the code on target address, this needs assembly */\n', '            length: = extcodesize(_addr)\n', '        }\n', '        return (length == 0);\n', '    }\n', '\n', '}\n', '\n', 'contract icocontract { //is inherently ERC20\n', '    using SafeMathMod\n', '    for uint256;\n', '\n', '    uint public raisedAmount = 0;\n', '    uint256 public RATE = 400;\n', '    bool public icostart = true;\n', '    address owner;\n', '\n', '    Usdcoins public token;\n', '\n', '    function icocontract() public {\n', '\n', '        owner = msg.sender;\n', '\n', '\n', '    }\n', '\n', '    modifier whenSaleIsActive() {\n', '        // Check if icostart is true\n', '        require(icostart == true);\n', '\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function setToken(Usdcoins _token) onlyOwner {\n', '\n', '        token = _token;\n', '\n', '    }\n', '\n', '    function setRate(uint256 rate) onlyOwner {\n', '\n', '        RATE = rate;\n', '\n', '    }\n', '\n', '\n', '    function setIcostart(bool newicostart) onlyOwner {\n', '\n', '        icostart = newicostart;\n', '    }\n', '\n', '    function() external payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function buyTokens() payable whenSaleIsActive {\n', '\n', '        // Calculate tokens to sell\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = weiAmount.mul(RATE);\n', '\n', '\n', '        // Increment raised amount\n', '        raisedAmount = raisedAmount.add(msg.value);\n', '\n', '        token.transferFrom(owner, msg.sender, tokens);\n', '\n', '\n', '        // Send money to owner\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'library SafeMathMod { // Partial SafeMath Library\n', '\n', '    function mul(uint256 a, uint256 b) constant internal returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) constant internal returns(uint256) {\n', '        assert(b != 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        require((c = a - b) < a);\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        require((c = a + b) > a);\n', '    }\n', '}\n', '\n', 'contract Usdcoins { //is inherently ERC20\n', '    using SafeMathMod\n', '    for uint256;\n', '\n', '    /**\n', '     * @constant name The name of the token\n', '     * @constant symbol  The symbol used to display the currency\n', '     * @constant decimals  The number of decimals used to dispay a balance\n', '     * @constant totalSupply The total number of tokens times 10^ of the number of decimals\n', '     * @constant MAX_UINT256 Magic number for unlimited allowance\n', '     * @storage balanceOf Holds the balances of all token holders\n', '     * @storage allowed Holds the allowable balance to be transferable by another address.\n', '     */\n', '\n', '    address owner;\n', '\n', '\n', '\n', '    string constant public name = "USDC";\n', '\n', '    string constant public symbol = "USDC";\n', '\n', '    uint256 constant public decimals = 18;\n', '\n', '    uint256 constant public totalSupply = 100000000e18;\n', '\n', '    uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    mapping(address => mapping(address => uint256)) public allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function() payable {\n', '        revert();\n', '    }\n', '\n', '    function Usdcoins() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '\n', '    /**\n', '     * @dev function that sells available tokens\n', '     */\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool success) {\n', '        /* Ensures that tokens are not sent to address "0x0" */\n', '        require(_to != address(0));\n', '        /* Prevents sending tokens directly to contracts. */\n', '\n', '\n', '        /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {\n', '        /* Ensures that tokens are not sent to address "0x0" */\n', '        require(_to != address(0));\n', '        /* Ensures tokens are not sent to this contract */\n', '\n', '\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/\n', '        require(_value <= allowance || _from == msg.sender);\n', '\n', '        /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '\n', '        /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */\n', '        /* Balance holder does not need allowance to send from self. */\n', '        if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amounts of tokens to the specified addresses.\n', '     * @dev Be aware that there is no check for duplicate recipients.\n', '     *\n', '     * @param _toAddresses Receiver addresses.\n', '     * @param _amounts Amounts of tokens that will be transferred.\n', '     */\n', '    function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {\n', '        /* Ensures _toAddresses array is less than or equal to 255 */\n', '        require(_toAddresses.length <= 255);\n', '        /* Ensures _toAddress and _amounts have the same number of entries. */\n', '        require(_toAddresses.length == _amounts.length);\n', '\n', '        for (uint8 i = 0; i < _toAddresses.length; i++) {\n', '            transfer(_toAddresses[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.\n', '     * @dev Be aware that there is no check for duplicate recipients.\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _toAddresses The addresses of the recipients (MAX 255)\n', '     * @param _amounts The amounts of tokens to be transferred\n', '     */\n', '    function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {\n', '        /* Ensures _toAddresses array is less than or equal to 255 */\n', '        require(_toAddresses.length <= 255);\n', '        /* Ensures _toAddress and _amounts have the same number of entries. */\n', '        require(_toAddresses.length == _amounts.length);\n', '\n', '        for (uint8 i = 0; i < _toAddresses.length; i++) {\n', '            transferFrom(_from, _toAddresses[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '     *\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool success) {\n', '        /* Ensures address "0x0" is not assigned allowance. */\n', '        require(_spender != address(0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns(uint256 remaining) {\n', '        remaining = allowed[_owner][_spender];\n', '    }\n', '\n', '    function isNotContract(address _addr) private view returns(bool) {\n', '        uint length;\n', '        assembly {\n', '            /* retrieve the size of the code on target address, this needs assembly */\n', '            length: = extcodesize(_addr)\n', '        }\n', '        return (length == 0);\n', '    }\n', '\n', '}\n', '\n', 'contract icocontract { //is inherently ERC20\n', '    using SafeMathMod\n', '    for uint256;\n', '\n', '    uint public raisedAmount = 0;\n', '    uint256 public RATE = 400;\n', '    bool public icostart = true;\n', '    address owner;\n', '\n', '    Usdcoins public token;\n', '\n', '    function icocontract() public {\n', '\n', '        owner = msg.sender;\n', '\n', '\n', '    }\n', '\n', '    modifier whenSaleIsActive() {\n', '        // Check if icostart is true\n', '        require(icostart == true);\n', '\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function setToken(Usdcoins _token) onlyOwner {\n', '\n', '        token = _token;\n', '\n', '    }\n', '\n', '    function setRate(uint256 rate) onlyOwner {\n', '\n', '        RATE = rate;\n', '\n', '    }\n', '\n', '\n', '    function setIcostart(bool newicostart) onlyOwner {\n', '\n', '        icostart = newicostart;\n', '    }\n', '\n', '    function() external payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function buyTokens() payable whenSaleIsActive {\n', '\n', '        // Calculate tokens to sell\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = weiAmount.mul(RATE);\n', '\n', '\n', '        // Increment raised amount\n', '        raisedAmount = raisedAmount.add(msg.value);\n', '\n', '        token.transferFrom(owner, msg.sender, tokens);\n', '\n', '\n', '        // Send money to owner\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '\n', '}']
