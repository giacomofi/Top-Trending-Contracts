['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-02\n', '*/\n', '\n', 'pragma solidity =0.8.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address to, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address to, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), owner);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Ownable: Caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address transferOwner) external onlyOwner {\n', '        require(transferOwner != newOwner);\n', '        newOwner = transferOwner;\n', '    }\n', '\n', '    function acceptOwnership() virtual public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', 'contract ERC20ToBEP20Wrapper is Ownable {\n', '    struct UnwrapInfo {\n', '        uint amount;\n', '        uint fee;\n', '        uint bscNonce;\n', '    }\n', '\n', '    IERC20 public immutable NBU;\n', '    uint public minWrapAmount;\n', '\n', '    mapping(address => uint) public userWrapNonces;\n', '    mapping(address => uint) public userUnwrapNonces;\n', '    mapping(address => mapping(uint => uint)) public bscToEthUserUnwrapNonces;\n', '    mapping(address => mapping(uint => uint)) public wraps;\n', '    mapping(address => mapping(uint => UnwrapInfo)) public unwraps;\n', '\n', '    event Wrap(address indexed user, uint indexed wrapNonce, uint amount);\n', '    event Unwrap(address indexed user, uint indexed unwrapNonce, uint indexed bscNonce, uint amount, uint fee);\n', '    event UpdateMinWrapAmount(uint indexed amount);\n', '    event Rescue(address indexed to, uint amount);\n', '    event RescueToken(address token, address indexed to, uint amount);\n', '\n', '    constructor(address nbu) {\n', '        NBU = IERC20(nbu);\n', '    }\n', '    \n', '    function wrap(uint amount) external {\n', '        require(amount >= minWrapAmount, "ERC20ToBEP20Wrapper: Value too small");\n', '        \n', '        NBU.transferFrom(msg.sender, address(this), amount);\n', '        uint userWrapNonce = ++userWrapNonces[msg.sender];\n', '        wraps[msg.sender][userWrapNonce] = amount;\n', '        emit Wrap(msg.sender, userWrapNonce, amount);\n', '    }\n', '\n', '    function unwrap(address user, uint amount, uint fee, uint bscNonce) external onlyOwner {\n', '        require(user != address(0), "ERC20ToBEP20Wrapper: Can\'t be zero address");\n', '        require(bscToEthUserUnwrapNonces[user][bscNonce] == 0, "ERC20ToBEP20Wrapper: Already processed");\n', '        \n', '        NBU.transfer(user, amount - fee);\n', '        uint unwrapNonce = ++userUnwrapNonces[user];\n', '        bscToEthUserUnwrapNonces[user][bscNonce] = unwrapNonce;\n', '        unwraps[user][unwrapNonce].amount = amount;\n', '        unwraps[user][unwrapNonce].fee = fee;\n', '        unwraps[user][unwrapNonce].bscNonce = bscNonce;\n', '        emit Unwrap(user, unwrapNonce, bscNonce, amount, fee);\n', '    }\n', '\n', '    //Admin functions\n', '    function rescue(address payable to, uint256 amount) external onlyOwner {\n', '        require(to != address(0), "ERC20ToBEP20Wrapper: Can\'t be zero address");\n', '        require(amount > 0, "ERC20ToBEP20Wrapper: Should be greater than 0");\n', '        TransferHelper.safeTransferETH(to, amount);\n', '        emit Rescue(to, amount);\n', '    }\n', '\n', '    function rescue(address to, address token, uint256 amount) external onlyOwner {\n', '        require(to != address(0), "ERC20ToBEP20Wrapper: Can\'t be zero address");\n', '        require(amount > 0, "ERC20ToBEP20Wrapper: Should be greater than 0");\n', '        TransferHelper.safeTransfer(token, to, amount);\n', '        emit RescueToken(token, to, amount);\n', '    }\n', '\n', '    function updateMinWrapAmount(uint amount) external onlyOwner {\n', '        require(amount > 0, "ERC20ToBEP20Wrapper: Should be greater than 0");\n', '        minWrapAmount = amount;\n', '        emit UpdateMinWrapAmount(amount);\n', '    }\n', '}']