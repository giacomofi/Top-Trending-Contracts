['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = false;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract CubegoCoreInterface {\n', '    function getMaterialSupply(uint _mId) constant external returns(uint);\n', '    function getMyMaterialById(address _owner, uint _mId) constant external returns(uint);\n', '    function transferMaterial(address _sender, address _receiver, uint _mId, uint _amount) external;\n', '}\n', '\n', 'contract CubegoFur is IERC20, BasicAccessControl {\n', '    using SafeMath for uint;\n', '    string public constant name = "CubegoFur";\n', '    string public constant symbol = "CUBFU";\n', '    uint public constant decimals = 0;\n', '    \n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    uint public mId = 3;\n', '    CubegoCoreInterface public cubegoCore;\n', '\n', '    function setConfig(address _cubegoCoreAddress, uint _mId) onlyModerators external {\n', '        cubegoCore = CubegoCoreInterface(_cubegoCoreAddress);\n', '        mId = _mId;\n', '    }\n', '\n', '    function emitTransferEvent(address from, address to, uint tokens) onlyModerators external {\n', '        emit Transfer(from, to, tokens);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return cubegoCore.getMaterialSupply(mId);\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return cubegoCore.getMyMaterialById(owner, mId);\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        cubegoCore.transferMaterial(msg.sender, to, mId, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        cubegoCore.transferMaterial(from, to, mId, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = (\n', '        _allowed[msg.sender][spender].add(addedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '}']