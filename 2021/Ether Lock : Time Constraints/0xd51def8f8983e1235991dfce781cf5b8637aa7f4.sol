['// SPDX-License-Identifier: LGPL-3.0-or-later\n', 'pragma solidity 0.5.17;\n', '\n', 'import "./Math.sol";\n', 'import "./SafeMath.sol";\n', 'import "./ReentrancyGuard.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./Owned.sol";\n', 'import "./Context.sol";\n', '\n', '\n', 'contract IRewardPool {\n', '    function notifyRewards(uint reward) external;\n', '}\n', '\n', 'contract Aggregator is Ownable, ReentrancyGuard {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint;\n', '\n', '    /// Protocol developers rewards\n', '    uint public constant FEE_FACTOR = 3;\n', '\n', '    // Beneficial address\n', '    address public beneficial;\n', '\n', '    /// Reward token\n', '    IERC20 public rewardToken;\n', '\n', '    // Reward pool address\n', '    address public rewardPool;\n', '\n', '    constructor(address _token1, address _rewardPool) public {\n', '        beneficial = msg.sender;\n', '        \n', '        rewardToken = IERC20(_token1);\n', '        rewardPool = _rewardPool;\n', '    }\n', '\n', '    /// Capture tokens or any other tokens\n', '    function capture(address _token) onlyOwner external {\n', '        require(_token != address(rewardToken), "capture: can not capture reward tokens");\n', '\n', '        uint balance = IERC20(_token).balanceOf(address(this));\n', '        IERC20(_token).safeTransfer(beneficial, balance);\n', '    }  \n', '\n', '    function notifyRewards() onlyOwner nonReentrant external {\n', '        uint reward = rewardToken.balanceOf(address(this));\n', '\n', '        /// Split the governance and protocol developers rewards\n', '        uint _developerRewards = reward.div(FEE_FACTOR);\n', '        uint _governanceRewards = reward.sub(_developerRewards);\n', '\n', '        rewardToken.safeTransfer(beneficial, _developerRewards);\n', '        rewardToken.safeTransfer(rewardPool, _governanceRewards);\n', '\n', '        IRewardPool(rewardPool).notifyRewards(_governanceRewards);\n', '    }\n', '}']