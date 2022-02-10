['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/network/AbstractDeployer.sol\n', '\n', 'contract AbstractDeployer is Ownable {\n', '    function title() public view returns(string);\n', '\n', '    function deploy(bytes data)\n', '        external onlyOwner returns(address result)\n', '    {\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        require(address(this).call(data), "Arbitrary call failed");\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            returndatacopy(0, 0, 32)\n', '            result := mload(0)\n', '        }\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol\n', '\n', '/**\n', ' * @title DetailedERC20 token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract DetailedERC20 is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '// File: contracts/ext/CheckedERC20.sol\n', '\n', 'library CheckedERC20 {\n', '    using SafeMath for uint;\n', '\n', '    function isContract(address addr) internal view returns(bool result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            result := gt(extcodesize(addr), 0)\n', '        }\n', '    }\n', '\n', '    function handleReturnBool() internal pure returns(bool result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            switch returndatasize()\n', '            case 0 { // not a std erc20\n', '                result := 1\n', '            }\n', '            case 32 { // std erc20\n', '                returndatacopy(0, 0, 32)\n', '                result := mload(0)\n', '            }\n', '            default { // anything else, should revert for safety\n', '                revert(0, 0)\n', '            }\n', '        }\n', '    }\n', '\n', '    function handleReturnBytes32() internal pure returns(bytes32 result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            if eq(returndatasize(), 32) { // not a std erc20\n', '                returndatacopy(0, 0, 32)\n', '                result := mload(0)\n', '            }\n', '            if gt(returndatasize(), 32) { // std erc20\n', '                returndatacopy(0, 64, 32)\n', '                result := mload(0)\n', '            }\n', '            if lt(returndatasize(), 32) { // anything else, should revert for safety\n', '                revert(0, 0)\n', '            }\n', '        }\n', '    }\n', '\n', '    function asmTransfer(address token, address to, uint256 value) internal returns(bool) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));\n', '        return handleReturnBool();\n', '    }\n', '\n', '    function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));\n', '        return handleReturnBool();\n', '    }\n', '\n', '    function asmApprove(address token, address spender, uint256 value) internal returns(bool) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));\n', '        return handleReturnBool();\n', '    }\n', '\n', '    //\n', '\n', '    function checkedTransfer(ERC20 token, address to, uint256 value) internal {\n', '        if (value > 0) {\n', '            uint256 balance = token.balanceOf(this);\n', '            asmTransfer(token, to, value);\n', '            require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn&#39;t match");\n', '        }\n', '    }\n', '\n', '    function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        if (value > 0) {\n', '            uint256 toBalance = token.balanceOf(to);\n', '            asmTransferFrom(token, from, to, value);\n', '            require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn&#39;t match");\n', '        }\n', '    }\n', '\n', '    //\n', '\n', '    function asmName(address token) internal view returns(bytes32) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        require(token.call(bytes4(keccak256("name()"))));\n', '        return handleReturnBytes32();\n', '    }\n', '\n', '    function asmSymbol(address token) internal view returns(bytes32) {\n', '        require(isContract(token));\n', '        // solium-disable-next-line security/no-low-level-calls\n', '        require(token.call(bytes4(keccak256("symbol()"))));\n', '        return handleReturnBytes32();\n', '    }\n', '}\n', '\n', '// File: contracts/ext/ERC1003Token.sol\n', '\n', 'contract ERC1003Caller is Ownable {\n', '    function makeCall(address target, bytes data) external payable onlyOwner returns (bool) {\n', '        // solium-disable-next-line security/no-call-value\n', '        return target.call.value(msg.value)(data);\n', '    }\n', '}\n', '\n', '\n', 'contract ERC1003Token is ERC20 {\n', '    ERC1003Caller private _caller = new ERC1003Caller();\n', '    address[] internal _sendersStack;\n', '\n', '    function caller() public view returns(ERC1003Caller) {\n', '        return _caller;\n', '    }\n', '\n', '    function approveAndCall(address to, uint256 value, bytes data) public payable returns (bool) {\n', '        _sendersStack.push(msg.sender);\n', '        approve(to, value);\n', '        require(_caller.makeCall.value(msg.value)(to, data));\n', '        _sendersStack.length -= 1;\n', '        return true;\n', '    }\n', '\n', '    function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool) {\n', '        transfer(to, value);\n', '        require(_caller.makeCall.value(msg.value)(to, data));\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        address spender = (from != address(_caller)) ? from : _sendersStack[_sendersStack.length - 1];\n', '        return super.transferFrom(spender, to, value);\n', '    }\n', '}\n', '\n', '// File: contracts/interface/IBasicMultiToken.sol\n', '\n', 'contract IBasicMultiToken is ERC20 {\n', '    event Bundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event Unbundle(address indexed who, address indexed beneficiary, uint256 value);\n', '\n', '    function tokensCount() public view returns(uint256);\n', '    function tokens(uint i) public view returns(ERC20);\n', '    \n', '    function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;\n', '    function bundle(address _beneficiary, uint256 _amount) public;\n', '\n', '    function unbundle(address _beneficiary, uint256 _value) public;\n', '    function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;\n', '\n', '    function disableBundling() public;\n', '    function enableBundling() public;\n', '}\n', '\n', '// File: contracts/BasicMultiToken.sol\n', '\n', 'contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken {\n', '    using CheckedERC20 for ERC20;\n', '    using CheckedERC20 for DetailedERC20;\n', '\n', '    ERC20[] private _tokens;\n', '    uint private _inLendingMode;\n', '    bool private _bundlingEnabled = true;\n', '\n', '    event Bundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event Unbundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event BundlingStatus(bool enabled);\n', '\n', '    modifier notInLendingMode {\n', '        require(_inLendingMode == 0, "Operation can&#39;t be performed while lending");\n', '        _;\n', '    }\n', '\n', '    modifier whenBundlingEnabled {\n', '        require(_bundlingEnabled, "Bundling is disabled");\n', '        _;\n', '    }\n', '\n', '    constructor(ERC20[] tokens, string name, string symbol, uint8 decimals)\n', '        public DetailedERC20(name, symbol, decimals)\n', '    {\n', '        require(decimals > 0, "constructor: _decimals should not be zero");\n', '        require(bytes(name).length > 0, "constructor: name should not be empty");\n', '        require(bytes(symbol).length > 0, "constructor: symbol should not be empty");\n', '        require(tokens.length >= 2, "Contract does not support less than 2 inner tokens");\n', '\n', '        _tokens = tokens;\n', '    }\n', '\n', '    function tokensCount() public view returns(uint) {\n', '        return _tokens.length;\n', '    }\n', '\n', '    function tokens(uint i) public view returns(ERC20) {\n', '        return _tokens[i];\n', '    }\n', '\n', '    function inLendingMode() public view returns(uint) {\n', '        return _inLendingMode;\n', '    }\n', '\n', '    function bundlingEnabled() public view returns(bool) {\n', '        return _bundlingEnabled;\n', '    }\n', '\n', '    function bundleFirstTokens(address beneficiary, uint256 amount, uint256[] tokenAmounts) public whenBundlingEnabled notInLendingMode {\n', '        require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");\n', '        _bundle(beneficiary, amount, tokenAmounts);\n', '    }\n', '\n', '    function bundle(address beneficiary, uint256 amount) public whenBundlingEnabled notInLendingMode {\n', '        require(totalSupply_ != 0, "This method can be used with non zero total supply only");\n', '        uint256[] memory tokenAmounts = new uint256[](_tokens.length);\n', '        for (uint i = 0; i < _tokens.length; i++) {\n', '            tokenAmounts[i] = _tokens[i].balanceOf(this).mul(amount).div(totalSupply_);\n', '        }\n', '        _bundle(beneficiary, amount, tokenAmounts);\n', '    }\n', '\n', '    function unbundle(address beneficiary, uint256 value) public notInLendingMode {\n', '        unbundleSome(beneficiary, value, _tokens);\n', '    }\n', '\n', '    function unbundleSome(address beneficiary, uint256 value, ERC20[] someTokens) public notInLendingMode {\n', '        _unbundle(beneficiary, value, someTokens);\n', '    }\n', '\n', '    // Admin methods\n', '\n', '    function disableBundling() public onlyOwner {\n', '        require(_bundlingEnabled, "Bundling is already disabled");\n', '        _bundlingEnabled = false;\n', '        emit BundlingStatus(false);\n', '    }\n', '\n', '    function enableBundling() public onlyOwner {\n', '        require(!_bundlingEnabled, "Bundling is already enabled");\n', '        _bundlingEnabled = true;\n', '        emit BundlingStatus(true);\n', '    }\n', '\n', '    // Internal methods\n', '\n', '    function _bundle(address beneficiary, uint256 amount, uint256[] tokenAmounts) internal {\n', '        require(amount != 0, "Bundling amount should be non-zero");\n', '        require(_tokens.length == tokenAmounts.length, "Lenghts of _tokens and tokenAmounts array should be equal");\n', '\n', '        for (uint i = 0; i < _tokens.length; i++) {\n', '            require(tokenAmounts[i] != 0, "Token amount should be non-zero");\n', '            _tokens[i].checkedTransferFrom(msg.sender, this, tokenAmounts[i]);\n', '        }\n', '\n', '        totalSupply_ = totalSupply_.add(amount);\n', '        balances[beneficiary] = balances[beneficiary].add(amount);\n', '        emit Bundle(msg.sender, beneficiary, amount);\n', '        emit Transfer(0, beneficiary, amount);\n', '    }\n', '\n', '    function _unbundle(address beneficiary, uint256 value, ERC20[] someTokens) internal {\n', '        require(someTokens.length > 0, "Array of someTokens can&#39;t be empty");\n', '\n', '        uint256 totalSupply = totalSupply_;\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        totalSupply_ = totalSupply.sub(value);\n', '        emit Unbundle(msg.sender, beneficiary, value);\n', '        emit Transfer(msg.sender, 0, value);\n', '\n', '        for (uint i = 0; i < someTokens.length; i++) {\n', '            for (uint j = 0; j < i; j++) {\n', '                require(someTokens[i] != someTokens[j], "unbundleSome: should not unbundle same token multiple times");\n', '            }\n', '            uint256 tokenAmount = someTokens[i].balanceOf(this).mul(value).div(totalSupply);\n', '            someTokens[i].checkedTransfer(beneficiary, tokenAmount);\n', '        }\n', '    }\n', '\n', '    // Instant Loans\n', '\n', '    function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {\n', '        uint256 prevBalance = token.balanceOf(this);\n', '        token.asmTransfer(to, amount);\n', '        _inLendingMode += 1;\n', '        require(caller().makeCall.value(msg.value)(target, data), "lend: arbitrary call failed");\n', '        _inLendingMode -= 1;\n', '        require(token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");\n', '    }\n', '}\n', '\n', '// File: contracts/network/BasicMultiTokenDeployer.sol\n', '\n', 'contract BasicMultiTokenDeployer is AbstractDeployer {\n', '    function title() public view returns(string) {\n', '        return "BasicMultiTokenDeployer";\n', '    }\n', '\n', '    function create(ERC20[] tokens, string name, string symbol, uint8 decimals)\n', '        external returns(address)\n', '    {\n', '        require(msg.sender == address(this), "Should be called only from deployer itself");\n', '        BasicMultiToken mtkn = new BasicMultiToken(tokens, name, symbol, decimals);\n', '        mtkn.transferOwnership(msg.sender);\n', '        return mtkn;\n', '    }\n', '}']