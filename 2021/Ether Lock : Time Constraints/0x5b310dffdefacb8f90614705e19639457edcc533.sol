['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-03\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'library Math {\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    constructor() internal {}\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash =\n', '            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    function toPayable(address account)\n', '        internal\n', '        pure\n', '        returns (address payable)\n', '    {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, value)\n', '        );\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance =\n', '            token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance =\n', '            token.allowance(address(this), spender).sub(\n', '                value,\n', '                "SafeERC20: decreased allowance below zero"\n', '            );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', 'contract LPTokenWrapper is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 public BUND_ETH = IERC20(0xEd86244cd91f4072C7c5b7F8Ec3A2E97EA31B693); // LP Token Here\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function stake(uint256 amount) public {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        BUND_ETH.safeTransferFrom(msg.sender, address(this), amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        BUND_ETH.safeTransfer(msg.sender, amount);\n', '    }\n', '}\n', '\n', 'contract StakeBUND_LP is LPTokenWrapper {\n', '    IERC20 public bundNFT = IERC20(0x92B3367515a7D2dF838c2ccD9F5e1Fc07D977C20); // Reward Token Here\n', '    \n', '    uint256 public constant duration = 30 days;\n', '    uint256 public starttime = 1614749400;                                      //-----| Starts immediately after deploy |-----                           \n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '    bool firstNotify;\n', '  \n', '    uint256 rewardAmount = 0;\n', '\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event Rewarded(address indexed from, address indexed to, uint256 value);\n', '\n', '    modifier checkStart() {\n', '        require(\n', '            block.timestamp >= starttime,\n', '            "BUND_BUNDNFT staking pool not started yet."\n', '        );\n', '        _;\n', '    }\n', '    \n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '    \n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '    \n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalSupply() == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable()\n', '                    .sub(lastUpdateTime)\n', '                    .mul(rewardRate)\n', '                    .mul(1e18)\n', '                    .div(totalSupply())\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return\n', '            balanceOf(account)\n', '                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '                .div(1e18)\n', '                .add(rewards[account]);\n', '    }\n', '\n', '    function stake(uint256 amount) public updateReward(msg.sender) checkStart {\n', '        require(amount > 0, "Cannot stake 0");\n', '        super.stake(amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount)\n', '        public\n', '        updateReward(msg.sender)\n', '    {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        super.withdraw(amount);\n', '    }\n', '\n', '    // withdraw stake and get rewards at once\n', '    function exit() external {\n', '        withdraw(balanceOf(msg.sender));\n', '        getReward();\n', '    }\n', '\n', '    function getReward() public updateReward(msg.sender){\n', '        uint256 reward = earned(msg.sender);\n', '\n', '        if (reward > 0) {\n', '            rewards[msg.sender] = 0;\n', '        \n', '            bundNFT.safeTransfer(msg.sender, reward);\n', '        }\n', '\n', '        \n', '    }\n', '\n', '    function permitNotifyReward() public view returns (bool) {    //-----| If current reward session has completed |---------\n', '        \n', '        if(block.timestamp > starttime.add(duration)){\n', '           return true;\n', '        }\n', '         \n', '    }\n', ' \n', '    function notifyRewardRate(uint256 _reward) public updateReward(address(0)) onlyOwner{\n', '       \n', '        require(permitNotifyReward() == true || firstNotify == false, "Cannot notify until previous reward session is completed");\n', '        rewardRate = _reward.div(duration);\n', '       \n', '        firstNotify = true;\n', '        lastUpdateTime = block.timestamp;\n', '        starttime = block.timestamp; \n', '        periodFinish = block.timestamp.add(duration);\n', '\n', '    }\n', '}']