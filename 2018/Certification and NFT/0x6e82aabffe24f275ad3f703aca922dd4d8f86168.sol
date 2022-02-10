['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BatchTransfer is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Withdraw(address indexed receiver, address indexed token, uint amount);\n', '    event TransferEther(address indexed sender, address indexed receiver, uint256 amount);\n', '\n', '    modifier checkArrayArgument(address[] _receivers, uint256[] _amounts) {\n', '        require(_receivers.length == _amounts.length && _receivers.length != 0);\n', '        _;\n', '    }\n', '\n', '    function batchTransferToken(address _token, address[] _receivers, uint256[] _tokenAmounts) public checkArrayArgument(_receivers, _tokenAmounts) {\n', '        require(_token != address(0));\n', '\n', '        ERC20 token = ERC20(_token);\n', '        require(allowanceForContract(_token) >= getTotalSendingAmount(_tokenAmounts));\n', '\n', '        for (uint i = 0; i < _receivers.length; i++) {\n', '            require(_receivers[i] != address(0));\n', '            require(token.transferFrom(msg.sender, _receivers[i], _tokenAmounts[i]));\n', '        }\n', '    }\n', '\n', '    function batchTransferEther(address[] _receivers, uint[] _amounts) public payable checkArrayArgument(_receivers, _amounts) {\n', '        require(msg.value != 0 && msg.value == getTotalSendingAmount(_amounts));\n', '\n', '        for (uint i = 0; i < _receivers.length; i++) {\n', '            require(_receivers[i] != address(0));\n', '            _receivers[i].transfer(_amounts[i]);\n', '            emit TransferEther(msg.sender, _receivers[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    function withdraw(address _receiver, address _token) public onlyOwner {\n', '        ERC20 token = ERC20(_token);\n', '        uint tokenBalanceOfContract = token.balanceOf(this);\n', '        require(_receiver != address(0) && tokenBalanceOfContract > 0);\n', '        require(token.transfer(_receiver, tokenBalanceOfContract));\n', '        emit Withdraw(_receiver, _token, tokenBalanceOfContract);\n', '    }\n', '\n', '    function balanceOfContract(address _token) public view returns (uint) {\n', '        ERC20 token = ERC20(_token);\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    function allowanceForContract(address _token) public view returns (uint) {\n', '        ERC20 token = ERC20(_token);\n', '        return token.allowance(msg.sender, this);\n', '    }\n', '\n', '    function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {\n', '        for (uint i = 0; i < _amounts.length; i++) {\n', '            require(_amounts[i] > 0);\n', '            totalSendingAmount = totalSendingAmount.add(_amounts[i]);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BatchTransfer is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Withdraw(address indexed receiver, address indexed token, uint amount);\n', '    event TransferEther(address indexed sender, address indexed receiver, uint256 amount);\n', '\n', '    modifier checkArrayArgument(address[] _receivers, uint256[] _amounts) {\n', '        require(_receivers.length == _amounts.length && _receivers.length != 0);\n', '        _;\n', '    }\n', '\n', '    function batchTransferToken(address _token, address[] _receivers, uint256[] _tokenAmounts) public checkArrayArgument(_receivers, _tokenAmounts) {\n', '        require(_token != address(0));\n', '\n', '        ERC20 token = ERC20(_token);\n', '        require(allowanceForContract(_token) >= getTotalSendingAmount(_tokenAmounts));\n', '\n', '        for (uint i = 0; i < _receivers.length; i++) {\n', '            require(_receivers[i] != address(0));\n', '            require(token.transferFrom(msg.sender, _receivers[i], _tokenAmounts[i]));\n', '        }\n', '    }\n', '\n', '    function batchTransferEther(address[] _receivers, uint[] _amounts) public payable checkArrayArgument(_receivers, _amounts) {\n', '        require(msg.value != 0 && msg.value == getTotalSendingAmount(_amounts));\n', '\n', '        for (uint i = 0; i < _receivers.length; i++) {\n', '            require(_receivers[i] != address(0));\n', '            _receivers[i].transfer(_amounts[i]);\n', '            emit TransferEther(msg.sender, _receivers[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    function withdraw(address _receiver, address _token) public onlyOwner {\n', '        ERC20 token = ERC20(_token);\n', '        uint tokenBalanceOfContract = token.balanceOf(this);\n', '        require(_receiver != address(0) && tokenBalanceOfContract > 0);\n', '        require(token.transfer(_receiver, tokenBalanceOfContract));\n', '        emit Withdraw(_receiver, _token, tokenBalanceOfContract);\n', '    }\n', '\n', '    function balanceOfContract(address _token) public view returns (uint) {\n', '        ERC20 token = ERC20(_token);\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    function allowanceForContract(address _token) public view returns (uint) {\n', '        ERC20 token = ERC20(_token);\n', '        return token.allowance(msg.sender, this);\n', '    }\n', '\n', '    function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {\n', '        for (uint i = 0; i < _amounts.length; i++) {\n', '            require(_amounts[i] > 0);\n', '            totalSendingAmount = totalSendingAmount.add(_amounts[i]);\n', '        }\n', '    }\n', '}']