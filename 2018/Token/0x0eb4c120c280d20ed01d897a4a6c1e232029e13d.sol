['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract MultiOwnable {\n', '    mapping (address => bool) owners;\n', '    address unremovableOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event OwnershipExtended(address indexed host, address indexed guest);\n', '    event OwnershipRemoved(address indexed removedOwner);\n', '\n', '    modifier onlyOwner() {\n', '        require(owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owners[msg.sender] = true;\n', '        unremovableOwner = msg.sender;\n', '    }\n', '\n', '    function addOwner(address guest) onlyOwner public {\n', '        require(guest != address(0));\n', '        owners[guest] = true;\n', '        emit OwnershipExtended(msg.sender, guest);\n', '    }\n', '\n', '    function removeOwner(address removedOwner) onlyOwner public {\n', '        require(removedOwner != address(0));\n', '        require(unremovableOwner != removedOwner);\n', '        delete owners[removedOwner];\n', '        emit OwnershipRemoved(removedOwner);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        require(unremovableOwner != msg.sender);\n', '        owners[newOwner] = true;\n', '        delete owners[msg.sender];\n', '        emit OwnershipTransferred(msg.sender, newOwner);\n', '    }\n', '\n', '    function isOwner(address addr) public view returns(bool){\n', '        return owners[addr];\n', '    }\n', '}\n', '\n', 'contract TokenLock is MultiOwnable {\n', '    ERC20 public token;\n', '    mapping (address => uint256) public lockAmounts;\n', '    mapping (address => uint256) public releaseBlocks;\n', '\n', '    constructor (address _token) public {\n', '        token = ERC20(_token);\n', '    }\n', '\n', '    function getLockAmount(address _addr) external view returns (uint256) {\n', '        return lockAmounts[_addr];\n', '    }\n', '\n', '    function getReleaseBlock(address _addr) external view returns (uint256) {\n', '        return releaseBlocks[_addr];\n', '    }\n', '\n', '    function lock(address _addr, uint256 _amount, uint256 _releaseBlock) external {\n', '        require(owners[msg.sender]);\n', '        require(_addr != address(0));\n', '        lockAmounts[_addr] = _amount;\n', '        releaseBlocks[_addr] = _releaseBlock;\n', '    }\n', '\n', '    function release(address _addr) external {\n', '        require(owners[msg.sender] || msg.sender == _addr);\n', '        require(block.number >= releaseBlocks[_addr]);\n', '        uint256 amount = lockAmounts[_addr];\n', '        lockAmounts[_addr] = 0;\n', '        releaseBlocks[_addr] = 0;\n', '        token.transfer(_addr, amount);\n', '    }\n', '}\n', '\n', 'contract TokenLockDistribute is Ownable {\n', '    ERC20 public token;\n', '    TokenLock public lock;\n', '\n', '    constructor (address _token, address _lock) public {\n', '        token = ERC20(_token);\n', '        lock = TokenLock(_lock);\n', '    }\n', '\n', '    function distribute(address _to, uint256 _unlockedAmount, uint256 _lockedAmount, uint256 _releaseBlockNumber) public onlyOwner {\n', '        require(_to != address(0));\n', '        token.transfer(address(lock), _lockedAmount);\n', '        lock.lock(_to, _lockedAmount, _releaseBlockNumber);\n', '        token.transfer(_to, _unlockedAmount);\n', '\n', '        emit Distribute(_to, _unlockedAmount, _lockedAmount, _releaseBlockNumber);\n', '    }\n', '\n', '    event Distribute(address indexed _to, uint256 _unlockedAmount, uint256 _lockedAmount, uint256 _releaseBlockNumber);\n', '}']