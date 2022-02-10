['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'import "./BoringERC20.sol";\n', 'import "./BoringMath.sol";\n', '\n', '\n', 'contract MC2Rewarder {\n', '    using BoringMath for uint256;\n', '    using BoringERC20 for IERC20;\n', '\n', '    address public owner;\n', '    uint256 public rewardMultiplier;\n', '    IERC20 public rewardToken;\n', '\n', '    uint256 private constant REWARD_TOKEN_DIVISOR = 1e18;\n', '    address private MASTERCHEF_V2;\n', '\n', '    constructor (address _owner, uint256 _rewardMultiplier, IERC20 _rewardToken, address _MASTERCHEF_V2) public {\n', '        owner = _owner;\n', '        rewardMultiplier = _rewardMultiplier;\n', '        rewardToken = _rewardToken;\n', '        MASTERCHEF_V2 = _MASTERCHEF_V2;\n', '    }\n', '\n', '    function setOwner(address _owner) public onlyOwner {\n', '        owner = _owner;\n', '    }\n', '\n', '    function setRewardMultiplier(uint256 _multiplier) public onlyOwner {\n', '        rewardMultiplier = _multiplier;\n', '    }\n', '\n', '    function onSushiReward (uint256, address, address to, uint256 sushiAmount, uint256) onlyMCV2 external {\n', '        uint256 pendingReward = sushiAmount.mul(rewardMultiplier) / REWARD_TOKEN_DIVISOR;\n', '        uint256 rewardBal = rewardToken.balanceOf(address(this));\n', '        if (pendingReward > rewardBal) {\n', '            rewardToken.safeTransfer(to, rewardBal);\n', '        } else {\n', '            rewardToken.safeTransfer(to, pendingReward);\n', '        }\n', '    }\n', '    \n', '    function pendingTokens(uint256, address, uint256 sushiAmount) external view returns (IERC20[] memory rewardTokens, uint256[] memory rewardAmounts) {\n', '        IERC20[] memory _rewardTokens = new IERC20[](1);\n', '        _rewardTokens[0] = (rewardToken);\n', '        uint256[] memory _rewardAmounts = new uint256[](1);\n', '        _rewardAmounts[0] = sushiAmount.mul(rewardMultiplier) / REWARD_TOKEN_DIVISOR;\n', '        return (_rewardTokens, _rewardAmounts);\n', '    }\n', '\n', '    modifier onlyMCV2 {\n', '        require(\n', '            msg.sender == MASTERCHEF_V2,\n', '            "Only MCV2 can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(\n', '            msg.sender == owner,\n', '            "Only owner can call this function."\n', '        );\n', '        _;\n', '    }\n', '  \n', '}']