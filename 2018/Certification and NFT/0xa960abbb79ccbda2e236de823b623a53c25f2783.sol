['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/interface/IBasicMultiToken.sol\n', '\n', 'contract IBasicMultiToken is ERC20 {\n', '    event Bundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event Unbundle(address indexed who, address indexed beneficiary, uint256 value);\n', '\n', '    function tokensCount() public view returns(uint256);\n', '    function tokens(uint256 _index) public view returns(ERC20);\n', '    function allTokens() public view returns(ERC20[]);\n', '    function allDecimals() public view returns(uint8[]);\n', '    function allBalances() public view returns(uint256[]);\n', '    function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);\n', '\n', '    function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;\n', '    function bundle(address _beneficiary, uint256 _amount) public;\n', '\n', '    function unbundle(address _beneficiary, uint256 _value) public;\n', '    function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;\n', '}\n', '\n', '// File: contracts/interface/IMultiToken.sol\n', '\n', 'contract IMultiToken is IBasicMultiToken {\n', '    event Update();\n', '    event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);\n', '\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);\n', '    function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);\n', '\n', '    function allWeights() public view returns(uint256[] _weights);\n', '    function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens\n', ' * @author SylTi\n', ' * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '   * @param token ERC20Basic The address of the token contract\n', '   */\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/registry/MultiBuyer.sol\n', '\n', 'contract MultiBuyer is CanReclaimToken {\n', '    using SafeMath for uint256;\n', '\n', '    function buy(\n', '        IMultiToken _mtkn,\n', '        uint256 _minimumReturn,\n', '        ERC20 _throughToken,\n', '        address[] _exchanges,\n', '        bytes _datas,\n', '        uint[] _datasIndexes, // including 0 and LENGTH values\n', '        uint256[] _values\n', '    )\n', '        public\n', '        payable\n', '    {\n', '        require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");\n', '        require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");\n', '\n', '        for (uint i = 0; i < _exchanges.length; i++) {\n', '            bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);\n', '            for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {\n', '                data[j - _datasIndexes[i]] = _datas[j];\n', '            }\n', '\n', '            if (_throughToken != address(0) && i > 0) {\n', '                _throughToken.approve(_exchanges[i], _throughToken.balanceOf(this));\n', '            }\n', '            require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");\n', '            if (_throughToken != address(0)) {\n', '                _throughToken.approve(_exchanges[i], 0);\n', '            }\n', '        }\n', '\n', '        j = _mtkn.totalSupply(); // optimization totalSupply\n', '        uint256 bestAmount = uint256(-1);\n', '        for (i = _mtkn.tokensCount(); i > 0; i--) {\n', '            ERC20 token = _mtkn.tokens(i - 1);\n', '            token.approve(_mtkn, token.balanceOf(this));\n', '\n', '            uint256 amount = j.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));\n', '            if (amount < bestAmount) {\n', '                bestAmount = amount;\n', '            }\n', '        }\n', '\n', '        require(bestAmount >= _minimumReturn, "buy: return value is too low");\n', '        _mtkn.bundle(msg.sender, bestAmount);\n', '        if (address(this).balance > 0) {\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/interface/IBasicMultiToken.sol\n', '\n', 'contract IBasicMultiToken is ERC20 {\n', '    event Bundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event Unbundle(address indexed who, address indexed beneficiary, uint256 value);\n', '\n', '    function tokensCount() public view returns(uint256);\n', '    function tokens(uint256 _index) public view returns(ERC20);\n', '    function allTokens() public view returns(ERC20[]);\n', '    function allDecimals() public view returns(uint8[]);\n', '    function allBalances() public view returns(uint256[]);\n', '    function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);\n', '\n', '    function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;\n', '    function bundle(address _beneficiary, uint256 _amount) public;\n', '\n', '    function unbundle(address _beneficiary, uint256 _value) public;\n', '    function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;\n', '}\n', '\n', '// File: contracts/interface/IMultiToken.sol\n', '\n', 'contract IMultiToken is IBasicMultiToken {\n', '    event Update();\n', '    event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);\n', '\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);\n', '    function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);\n', '\n', '    function allWeights() public view returns(uint256[] _weights);\n', '    function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens\n', ' * @author SylTi\n', ' * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '   * @param token ERC20Basic The address of the token contract\n', '   */\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/registry/MultiBuyer.sol\n', '\n', 'contract MultiBuyer is CanReclaimToken {\n', '    using SafeMath for uint256;\n', '\n', '    function buy(\n', '        IMultiToken _mtkn,\n', '        uint256 _minimumReturn,\n', '        ERC20 _throughToken,\n', '        address[] _exchanges,\n', '        bytes _datas,\n', '        uint[] _datasIndexes, // including 0 and LENGTH values\n', '        uint256[] _values\n', '    )\n', '        public\n', '        payable\n', '    {\n', '        require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");\n', '        require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");\n', '\n', '        for (uint i = 0; i < _exchanges.length; i++) {\n', '            bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);\n', '            for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {\n', '                data[j - _datasIndexes[i]] = _datas[j];\n', '            }\n', '\n', '            if (_throughToken != address(0) && i > 0) {\n', '                _throughToken.approve(_exchanges[i], _throughToken.balanceOf(this));\n', '            }\n', '            require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");\n', '            if (_throughToken != address(0)) {\n', '                _throughToken.approve(_exchanges[i], 0);\n', '            }\n', '        }\n', '\n', '        j = _mtkn.totalSupply(); // optimization totalSupply\n', '        uint256 bestAmount = uint256(-1);\n', '        for (i = _mtkn.tokensCount(); i > 0; i--) {\n', '            ERC20 token = _mtkn.tokens(i - 1);\n', '            token.approve(_mtkn, token.balanceOf(this));\n', '\n', '            uint256 amount = j.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));\n', '            if (amount < bestAmount) {\n', '                bestAmount = amount;\n', '            }\n', '        }\n', '\n', '        require(bestAmount >= _minimumReturn, "buy: return value is too low");\n', '        _mtkn.bundle(msg.sender, bestAmount);\n', '        if (address(this).balance > 0) {\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '    }\n', '}']
