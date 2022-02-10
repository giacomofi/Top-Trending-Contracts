['pragma solidity ^0.4.22;\n', '\n', '// File: contracts/interfaces/IERC20Token.sol\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: contracts/Main.sol\n', '\n', 'contract Bancor {\n', '    function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)\n', '    public\n', '    payable\n', '    returns (uint256);\n', '\n', '}\n', '\n', 'contract Main is Claimable {\n', '\n', '    Bancor bancor;\n', '\n', '    function Main(address _bancor) {\n', '        bancor = Bancor(_bancor);\n', '    }\n', '\n', '    function transferToken(\n', '        address[] path,\n', '        address receiverAddress,\n', '        address executor,\n', '        uint256 amount\n', '    )\n', '    public\n', '    returns\n', '    (\n', '        bool\n', '    )\n', '    {\n', '        //TODO: require\n', '        //TODO: events\n', '\n', '        IERC20Token[] memory pathConverted = new IERC20Token[](path.length);\n', '\n', '        for (uint i = 0; i < path.length; i++) {\n', '            pathConverted[i] = IERC20Token(path[i]);\n', '        }\n', '\n', '        require(IERC20Token(path[0]).transferFrom(msg.sender, address(this), amount), "transferFrom msg.sender failed");\n', '        require(IERC20Token(path[0]).approve(address(bancor), amount), "approve to bancor failed");\n', '        uint256 amountReceived = bancor.quickConvert(pathConverted, amount, 1);\n', '        require(IERC20Token(path[path.length - 1]).transfer(receiverAddress, amountReceived), "transfer back to receiverAddress failed");\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.22;\n', '\n', '// File: contracts/interfaces/IERC20Token.sol\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: contracts/Main.sol\n', '\n', 'contract Bancor {\n', '    function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)\n', '    public\n', '    payable\n', '    returns (uint256);\n', '\n', '}\n', '\n', 'contract Main is Claimable {\n', '\n', '    Bancor bancor;\n', '\n', '    function Main(address _bancor) {\n', '        bancor = Bancor(_bancor);\n', '    }\n', '\n', '    function transferToken(\n', '        address[] path,\n', '        address receiverAddress,\n', '        address executor,\n', '        uint256 amount\n', '    )\n', '    public\n', '    returns\n', '    (\n', '        bool\n', '    )\n', '    {\n', '        //TODO: require\n', '        //TODO: events\n', '\n', '        IERC20Token[] memory pathConverted = new IERC20Token[](path.length);\n', '\n', '        for (uint i = 0; i < path.length; i++) {\n', '            pathConverted[i] = IERC20Token(path[i]);\n', '        }\n', '\n', '        require(IERC20Token(path[0]).transferFrom(msg.sender, address(this), amount), "transferFrom msg.sender failed");\n', '        require(IERC20Token(path[0]).approve(address(bancor), amount), "approve to bancor failed");\n', '        uint256 amountReceived = bancor.quickConvert(pathConverted, amount, 1);\n', '        require(IERC20Token(path[path.length - 1]).transfer(receiverAddress, amountReceived), "transfer back to receiverAddress failed");\n', '        return true;\n', '    }\n', '\n', '}']
