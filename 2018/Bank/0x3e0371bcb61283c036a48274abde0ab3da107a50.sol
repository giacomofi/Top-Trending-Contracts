['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  /// @return total amount of tokens\n', '  function totalSupply() public constant returns (uint256 supply);\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', 'contract Gateway is Ownable{\n', '    using SafeMath for uint;\n', '    address public feeAccount1 = 0x703f9037088A93853163aEaaEd650f3e66aD7A4e; //the account1 that will receive fees\n', '    address public feeAccount2 = 0xc94cac4a4537865753ecdf2ad48F00112dC09ea8; //the account2 that will receive fees\n', '    address public feeAccountToken = 0x2EF9B82Ab8Bb8229B3D863A47B1188672274E1aC;//the account that will receive fees tokens\n', '    \n', '    struct BuyInfo {\n', '      address buyerAddress; \n', '      address sellerAddress;\n', '      uint value;\n', '      address currency;\n', '    }\n', '    \n', '    mapping(address => mapping(uint => BuyInfo)) public payment;\n', '   \n', '    uint balanceFee;\n', '    uint public feePercent;\n', '    uint public maxFee;\n', '    constructor() public{\n', '       feePercent = 1500000; // decimals 6. 1,5% fee by default\n', '       maxFee = 3000000; // fee can not exceed 3%\n', '    }\n', '    \n', '    \n', '    function getBuyerAddressPayment(address _sellerAddress, uint _orderId) public constant returns(address){\n', '      return  payment[_sellerAddress][_orderId].buyerAddress;\n', '    }    \n', '    function getSellerAddressPayment(address _sellerAddress, uint _orderId) public constant returns(address){\n', '      return  payment[_sellerAddress][_orderId].sellerAddress;\n', '    }    \n', '    \n', '    function getValuePayment(address _sellerAddress, uint _orderId) public constant returns(uint){\n', '      return  payment[_sellerAddress][_orderId].value;\n', '    }    \n', '    \n', '    function getCurrencyPayment(address _sellerAddress, uint _orderId) public constant returns(address){\n', '      return  payment[_sellerAddress][_orderId].currency;\n', '    }\n', '    \n', '    \n', '    function setFeeAccount1(address _feeAccount1) onlyOwner public{\n', '      feeAccount1 = _feeAccount1;  \n', '    }\n', '    function setFeeAccount2(address _feeAccount2) onlyOwner public{\n', '      feeAccount2 = _feeAccount2;  \n', '    }\n', '    function setFeeAccountToken(address _feeAccountToken) onlyOwner public{\n', '      feeAccountToken = _feeAccountToken;  \n', '    }    \n', '    function setFeePercent(uint _feePercent) onlyOwner public{\n', '      require(_feePercent <= maxFee);\n', '      feePercent = _feePercent;  \n', '    }    \n', '    function payToken(address _tokenAddress, address _sellerAddress, uint _orderId,  uint _value) public returns (bool success){\n', '      require(_tokenAddress != address(0));\n', '      require(_sellerAddress != address(0)); \n', '      require(_value > 0);\n', '      Token token = Token(_tokenAddress);\n', '      require(token.allowance(msg.sender, this) >= _value);\n', '      token.transferFrom(msg.sender, feeAccountToken, _value.mul(feePercent).div(100000000));\n', '      token.transferFrom(msg.sender, _sellerAddress, _value.sub(_value.mul(feePercent).div(100000000)));\n', '      payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, _tokenAddress);\n', '      success = true;\n', '    }\n', '    function payEth(address _sellerAddress, uint _orderId, uint _value) internal returns  (bool success){\n', '      require(_sellerAddress != address(0)); \n', '      require(_value > 0);\n', '      uint fee = _value.mul(feePercent).div(100000000);\n', '      _sellerAddress.transfer(_value.sub(fee));\n', '      balanceFee = balanceFee.add(fee);\n', '      payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, 0x0000000000000000000000000000000000000001);    \n', '      success = true;\n', '    }\n', '    function transferFee() onlyOwner public{\n', '      uint valfee1 = balanceFee.div(2);\n', '      feeAccount1.transfer(valfee1);\n', '      balanceFee = balanceFee.sub(valfee1);\n', '      feeAccount2.transfer(balanceFee);\n', '      balanceFee = 0;\n', '    }\n', '    function balanceOfToken(address _tokenAddress, address _Address) public constant returns (uint) {\n', '      Token token = Token(_tokenAddress);\n', '      return token.balanceOf(_Address);\n', '    }\n', '    function balanceOfEthFee() public constant returns (uint) {\n', '      return balanceFee;\n', '    }\n', '    function bytesToAddress(bytes source) internal pure returns(address) {\n', '      uint result;\n', '      uint mul = 1;\n', '      for(uint i = 20; i > 0; i--) {\n', '        result += uint8(source[i-1])*mul;\n', '        mul = mul*256;\n', '      }\n', '      return address(result);\n', '    }\n', '    function() external payable {\n', '      require(msg.data.length == 20); \n', '      require(msg.value > 99999999999);\n', '      address sellerAddress = bytesToAddress(bytes(msg.data));\n', '      uint value = msg.value.div(10000000000).mul(10000000000);\n', '      uint orderId = msg.value.sub(value);\n', '      balanceFee = balanceFee.add(orderId);\n', '      payEth(sellerAddress, orderId, value);\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  /// @return total amount of tokens\n', '  function totalSupply() public constant returns (uint256 supply);\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', 'contract Gateway is Ownable{\n', '    using SafeMath for uint;\n', '    address public feeAccount1 = 0x703f9037088A93853163aEaaEd650f3e66aD7A4e; //the account1 that will receive fees\n', '    address public feeAccount2 = 0xc94cac4a4537865753ecdf2ad48F00112dC09ea8; //the account2 that will receive fees\n', '    address public feeAccountToken = 0x2EF9B82Ab8Bb8229B3D863A47B1188672274E1aC;//the account that will receive fees tokens\n', '    \n', '    struct BuyInfo {\n', '      address buyerAddress; \n', '      address sellerAddress;\n', '      uint value;\n', '      address currency;\n', '    }\n', '    \n', '    mapping(address => mapping(uint => BuyInfo)) public payment;\n', '   \n', '    uint balanceFee;\n', '    uint public feePercent;\n', '    uint public maxFee;\n', '    constructor() public{\n', '       feePercent = 1500000; // decimals 6. 1,5% fee by default\n', '       maxFee = 3000000; // fee can not exceed 3%\n', '    }\n', '    \n', '    \n', '    function getBuyerAddressPayment(address _sellerAddress, uint _orderId) public constant returns(address){\n', '      return  payment[_sellerAddress][_orderId].buyerAddress;\n', '    }    \n', '    function getSellerAddressPayment(address _sellerAddress, uint _orderId) public constant returns(address){\n', '      return  payment[_sellerAddress][_orderId].sellerAddress;\n', '    }    \n', '    \n', '    function getValuePayment(address _sellerAddress, uint _orderId) public constant returns(uint){\n', '      return  payment[_sellerAddress][_orderId].value;\n', '    }    \n', '    \n', '    function getCurrencyPayment(address _sellerAddress, uint _orderId) public constant returns(address){\n', '      return  payment[_sellerAddress][_orderId].currency;\n', '    }\n', '    \n', '    \n', '    function setFeeAccount1(address _feeAccount1) onlyOwner public{\n', '      feeAccount1 = _feeAccount1;  \n', '    }\n', '    function setFeeAccount2(address _feeAccount2) onlyOwner public{\n', '      feeAccount2 = _feeAccount2;  \n', '    }\n', '    function setFeeAccountToken(address _feeAccountToken) onlyOwner public{\n', '      feeAccountToken = _feeAccountToken;  \n', '    }    \n', '    function setFeePercent(uint _feePercent) onlyOwner public{\n', '      require(_feePercent <= maxFee);\n', '      feePercent = _feePercent;  \n', '    }    \n', '    function payToken(address _tokenAddress, address _sellerAddress, uint _orderId,  uint _value) public returns (bool success){\n', '      require(_tokenAddress != address(0));\n', '      require(_sellerAddress != address(0)); \n', '      require(_value > 0);\n', '      Token token = Token(_tokenAddress);\n', '      require(token.allowance(msg.sender, this) >= _value);\n', '      token.transferFrom(msg.sender, feeAccountToken, _value.mul(feePercent).div(100000000));\n', '      token.transferFrom(msg.sender, _sellerAddress, _value.sub(_value.mul(feePercent).div(100000000)));\n', '      payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, _tokenAddress);\n', '      success = true;\n', '    }\n', '    function payEth(address _sellerAddress, uint _orderId, uint _value) internal returns  (bool success){\n', '      require(_sellerAddress != address(0)); \n', '      require(_value > 0);\n', '      uint fee = _value.mul(feePercent).div(100000000);\n', '      _sellerAddress.transfer(_value.sub(fee));\n', '      balanceFee = balanceFee.add(fee);\n', '      payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, 0x0000000000000000000000000000000000000001);    \n', '      success = true;\n', '    }\n', '    function transferFee() onlyOwner public{\n', '      uint valfee1 = balanceFee.div(2);\n', '      feeAccount1.transfer(valfee1);\n', '      balanceFee = balanceFee.sub(valfee1);\n', '      feeAccount2.transfer(balanceFee);\n', '      balanceFee = 0;\n', '    }\n', '    function balanceOfToken(address _tokenAddress, address _Address) public constant returns (uint) {\n', '      Token token = Token(_tokenAddress);\n', '      return token.balanceOf(_Address);\n', '    }\n', '    function balanceOfEthFee() public constant returns (uint) {\n', '      return balanceFee;\n', '    }\n', '    function bytesToAddress(bytes source) internal pure returns(address) {\n', '      uint result;\n', '      uint mul = 1;\n', '      for(uint i = 20; i > 0; i--) {\n', '        result += uint8(source[i-1])*mul;\n', '        mul = mul*256;\n', '      }\n', '      return address(result);\n', '    }\n', '    function() external payable {\n', '      require(msg.data.length == 20); \n', '      require(msg.value > 99999999999);\n', '      address sellerAddress = bytesToAddress(bytes(msg.data));\n', '      uint value = msg.value.div(10000000000).mul(10000000000);\n', '      uint orderId = msg.value.sub(value);\n', '      balanceFee = balanceFee.add(orderId);\n', '      payEth(sellerAddress, orderId, value);\n', '  }\n', '}']
