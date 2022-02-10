['// SPDX-License-Identifier: MIT\n', '\n', '// Burning Network\n', '// Total Supply - 21000 BURN\n', '// Website: https://burning.network/\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    \n', '    function ceil(uint256 a, uint256 m) internal pure returns (uint256 r) {\n', '        return (a + m - 1) / m * m;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function amountToTransfer(uint256 amount) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @Burning-Network/contracts/Staking.sol\n', '\n', 'contract Staking is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _stakes;\n', '    mapping (address => uint256) private _time;\n', '\n', '    IERC20 public contractAddress;\n', '    \n', '    uint256 public stakingPool;\n', '    uint256 private chargeFee = 500; // 5%\n', '    uint256 public initialAmount;\n', '    uint256 public totalFee;\n', '    uint256 public rewardPool;\n', '\n', '    constructor(IERC20 _contractAddress) {\n', '        contractAddress = _contractAddress;\n', '    }\n', '    \n', '    function amountToCharge(uint256 amount) internal virtual returns (uint256) {\n', '        uint256 _amount = amount.ceil(chargeFee).mul(chargeFee).div(10000);\n', '        return _amount;\n', '    }\n', '    \n', '    function approvedAmount(address owner) public view returns (uint256) {\n', '        return contractAddress.allowance(owner, address(this));\n', '    }\n', '    \n', '    function stakeOf(address account) public view returns (uint256) {\n', '        return _stakes[account];\n', '    }\n', '    \n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return contractAddress.balanceOf(account);\n', '    }\n', '    \n', '    function chargePercent() public view returns (uint256) {\n', '        uint256 _chargeFee = chargeFee.div(100);\n', '        return _chargeFee;\n', '    }\n', '\n', '    // Transfer initial amount to the staking contract (only for owner)\n', '    function addToContract(uint256 amount) public virtual onlyOwner {\n', '        uint256 amountForPool = contractAddress.amountToTransfer(amount);\n', '        \n', '        initialAmount = initialAmount.add(amountForPool);\n', '        rewardPool = rewardPool.add(amountForPool);\n', '        \n', '        contractAddress.transferFrom(msg.sender, address(this), amount);\n', '    }\n', '    \n', '    // Function to stake tokens\n', '    function stakeTokens(uint256 amount) external {\n', '        require(initialAmount != 0, "Wait for official announcement");\n', '        require(contractAddress.balanceOf(msg.sender) >= amount, "Your current balance is less than the amount for staking");\n', '        require(contractAddress.allowance(msg.sender, address(this)) >= amount, "Please approve tokens before staking");\n', '\n', '        uint256 _amountToCharge = amountToCharge(contractAddress.amountToTransfer(amount));\n', '        uint256 _amountToTransfer = contractAddress.amountToTransfer(amount).sub(_amountToCharge);\n', '\n', '        _stakes[msg.sender] = _stakes[msg.sender].add(_amountToTransfer);\n', '        _time[msg.sender] = block.timestamp;\n', '        totalFee = totalFee.add(_amountToCharge);\n', '        stakingPool = stakingPool.add(_amountToCharge).add(_amountToTransfer);\n', '        rewardPool = rewardPool.add(totalFee);\n', '\n', '        contractAddress.transferFrom(msg.sender, address(this), amount);\n', '    }\n', '\n', '    // Function to calculate your current reward\n', '    function calculateReward() internal virtual returns (uint256) {\n', '        uint256 amount = rewardPool.mul(_stakes[msg.sender]).div(stakingPool);\n', '        uint256 stakingTime = block.timestamp.sub(_time[msg.sender]);\n', '        uint256 reward = amount.mul(3).mul(stakingTime).div(10 ** 6);\n', '\n', '        // Probably will not happened but I feel more confident when I see it here:\n', '        if (reward > rewardPool) {\n', '            uint256 _reward = rewardPool.div(2);\n', '            \n', '            _stakes[msg.sender] = _stakes[msg.sender].sub(_reward);\n', '            rewardPool = rewardPool.sub(_reward);\n', '            \n', '            return _reward;\n', '        }    \n', '\n', '        return reward;\n', '    }\n', '    \n', '    // Function to check your current reward\n', '    function checkReward(address account) public view returns (uint256) {\n', '        uint256 amount = rewardPool.mul(_stakes[account]).div(stakingPool);\n', '        uint256 stakingTime = block.timestamp.sub(_time[account]);\n', '        uint256 reward = amount.mul(3).mul(stakingTime).div(10 ** 6);\n', '\n', '        if (reward > rewardPool) {\n', '            uint256 _reward = rewardPool.div(2);\n', '            return _reward;\n', '        }  \n', '\n', '        return reward;\n', '    }\n', '    \n', '    // Function to get reward from the balance of the staking contract\n', '    function claimReward() external {\n', '        uint256 reward = calculateReward();\n', '        \n', '        _time[msg.sender] = block.timestamp;\n', '        \n', '        rewardPool = rewardPool.sub(reward);\n', '        \n', '        contractAddress.transfer(msg.sender, reward);\n', '    }\n', '    \n', '    // Function to remove staking tokens\n', '    // You need to claim reward before unstaking or you will lose your reward\n', '    function removeStake(uint256 amount) external {\n', '        _stakes[msg.sender] = _stakes[msg.sender].sub(amount);\n', '\n', '        stakingPool = stakingPool.sub(amount);\n', '        \n', '        contractAddress.transfer(msg.sender, amount);\n', '    }\n', '}']