['pragma solidity ^0.5.0;\n', '\n', 'contract Context {\n', '    constructor () internal {}\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly {codehash := extcodehash(account)}\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '        (bool success,) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) {// Return data is optional\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IFairStockEquity {\n', '    function business(address user, uint256 payAmount, uint256 availableAmount, uint256 bonusAmount) external;\n', '\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IFSERandom {\n', '    function genRandom(uint256 seed) external returns (bytes32);\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract FSEGoldMiner is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IFairStockEquity public FairStockEquity;\n', '    IFSERandom public FSERandom;\n', '    IERC20 public mainToken;\n', '    uint256 public running = 1;\n', '    uint256 public stakeMin = 10 * (10 ** 18);\n', '    uint256 public stakeMax = 200 * (10 ** 18);\n', '    mapping(address => uint256) public users;\n', '\n', '    event ePlay(address indexed user, uint256 payAmount, uint256 bonusAmount, uint256 timestamp);\n', '\n', '    modifier onlyRunning() {\n', '        require(running == 1, "Contract is not running!");\n', '        _;\n', '    }\n', '\n', '    modifier onlyRegisted() {\n', '        require(users[_msgSender()] > 0 && users[_msgSender()] < block.timestamp, "User NOT regist!");\n', '        require(!Address.isContract(_msgSender()), "Illegal address!");\n', '        _;\n', '    }\n', '\n', '    constructor (address _fairStockEquity, address _fseRandom, address _mainToken) public {\n', '        mainToken = IERC20(_mainToken);\n', '        setFairStockEquity(_fairStockEquity);\n', '        setFSERandom(_fseRandom);\n', '    }\n', '\n', '    function setFairStockEquity(address addr)\n', '    public onlyOwner {\n', '        FairStockEquity = IFairStockEquity(addr);\n', '        _setTokenApprove(addr);\n', '    }\n', '\n', '    function setFSERandom(address addr)\n', '    public onlyOwner {\n', '        FSERandom = IFSERandom(addr);\n', '    }\n', '\n', '    function setRunning(uint256 _running)\n', '    public onlyOwner {\n', '        running = _running;\n', '    }\n', '\n', '    function _setTokenApprove(address addr)\n', '    internal {\n', '        mainToken.approve(address(addr), uint(- 1));\n', '    }\n', '\n', '    function setStakeAmounts(uint256 _stakeMin, uint256 _stakeMax)\n', '    public onlyOwner {\n', '        stakeMin = _stakeMin;\n', '        stakeMax = _stakeMax;\n', '    }\n', '\n', '    function regist()\n', '    public {\n', '        users[_msgSender()] = block.timestamp;\n', '    }\n', '\n', '    function getStakeAmounts()\n', '    public view\n', '    returns (uint256 _stakeMin, uint256 _stakeMax){\n', '        return (stakeMin, stakeMax);\n', '    }\n', '\n', '    function play(uint256 payAmount)\n', '    public onlyRunning onlyRegisted {\n', '        require(payAmount >= stakeMin, "The amount is too little!");\n', '        require(mainToken.allowance(_msgSender(), address(this)) >= payAmount, "The allowance is too little!");\n', '        mainToken.safeTransferFrom(_msgSender(), address(this), payAmount);\n', '\n', '        uint256 randNumber = uint256(FSERandom.genRandom(uint256(\n', '                keccak256(abi.encodePacked(block.timestamp, block.difficulty, _msgSender(), payAmount, gasleft())))));\n', '\n', '        uint256 amount = payAmount;\n', '        uint256 bonusAmount = 0;\n', '        uint256 betAmount = 0;\n', '        uint256 bonus = 0;\n', '        uint256 availableAmount = 0;\n', '        while (amount > 0) {\n', '            if (amount > stakeMax) {\n', '                betAmount = stakeMax;\n', '            } else {\n', '                betAmount = amount;\n', '            }\n', '            amount = amount.sub(betAmount);\n', '\n', '            randNumber = uint256(keccak256(abi.encodePacked(block.difficulty, randNumber, bonusAmount, gasleft())));\n', '\n', '            bonus = betAmount.mul(randNumber % 100).div(55);\n', '            if (bonus < betAmount) {\n', '                availableAmount = availableAmount + betAmount;\n', '            }\n', '            bonusAmount = bonusAmount + bonus;\n', '        }\n', '\n', '        FairStockEquity.business(_msgSender(), payAmount, availableAmount, bonusAmount);\n', '        emit ePlay(_msgSender(), payAmount, bonusAmount, block.timestamp);\n', '    }\n', '}']