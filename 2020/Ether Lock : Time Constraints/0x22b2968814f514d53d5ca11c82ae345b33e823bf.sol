['// File: @openzeppelin\\contracts\\token\\ERC20\\IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts\\VampireAdapter.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', 'contract Victim{}\n', '\n', 'library VampireAdapter {\n', '    // Victim info\n', '    function rewardToken(Victim victim) external view returns (IERC20) {\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("rewardToken()"));\n', '        require(success, "rewardToken() staticcall failed.");\n', '        return abi.decode(result, (IERC20));\n', '    }\n', '\n', '    function poolCount(Victim victim) external view returns (uint256) {\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("poolCount()"));\n', '        require(success, "poolCount() staticcall failed.");\n', '        return abi.decode(result, (uint256));\n', '    }\n', '\n', '    function sellableRewardAmount(Victim victim) external view returns (uint256) {\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("sellableRewardAmount()"));\n', '        require(success, "sellableRewardAmount() staticcall failed.");\n', '        return abi.decode(result, (uint256));\n', '    }\n', '\n', '    // Victim actions\n', '    function sellRewardForWeth(Victim victim, uint256 rewardAmount, address to) external returns(uint256) {\n', '        (bool success, bytes memory result) = address(victim).delegatecall(abi.encodeWithSignature("sellRewardForWeth(address,uint256,address)", address(victim), rewardAmount, to));\n', '        require(success, "sellRewardForWeth(uint256 rewardAmount, address to) delegatecall failed.");\n', '        return abi.decode(result, (uint256));\n', '    }\n', '\n', '    // Pool info\n', '    function lockableToken(Victim victim, uint256 poolId) external view returns (IERC20) {\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("lockableToken(uint256)", poolId));\n', '        require(success, "lockableToken(uint256 poolId) staticcall failed.");\n', '        return abi.decode(result, (IERC20));\n', '    }\n', '\n', '    function lockedAmount(Victim victim, uint256 poolId) external view returns (uint256) {\n', '        // note the impersonation\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("lockedAmount(address,uint256)", address(this), poolId));\n', '        require(success, "lockedAmount(uint256 poolId) staticcall failed.");\n', '        return abi.decode(result, (uint256));\n', '    }\n', '\n', '    // Pool actions\n', '    function deposit(Victim victim, uint256 poolId, uint256 amount) external {\n', '        (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("deposit(address,uint256,uint256)", address(victim), poolId, amount));\n', '        require(success, "deposit(uint256 poolId, uint256 amount) delegatecall failed.");\n', '    }\n', '\n', '    function withdraw(Victim victim, uint256 poolId, uint256 amount) external {\n', '        (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("withdraw(address,uint256,uint256)", address(victim), poolId, amount));\n', '        require(success, "withdraw(uint256 poolId, uint256 amount) delegatecall failed.");\n', '    }\n', '    \n', '    function claimReward(Victim victim, uint256 poolId) external {\n', '        (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("claimReward(address,uint256)", address(victim), poolId));\n', '        require(success, "claimReward(uint256 poolId) delegatecall failed.");\n', '    }\n', '    \n', '    function emergencyWithdraw(Victim victim, uint256 poolId) external {\n', '        (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("emergencyWithdraw(address,uint256)", address(victim), poolId));\n', '        require(success, "emergencyWithdraw(uint256 poolId) delegatecall failed.");\n', '    }\n', '    \n', '    // Service methods\n', '    function poolAddress(Victim victim, uint256 poolId) external view returns (address) {\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("poolAddress(uint256)", poolId));\n', '        require(success, "poolAddress(uint256 poolId) staticcall failed.");\n', '        return abi.decode(result, (address));\n', '    }\n', '\n', '    function rewardToWethPool(Victim victim) external view returns (address) {\n', '        (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("rewardToWethPool()"));\n', '        require(success, "rewardToWethPool() staticcall failed.");\n', '        return abi.decode(result, (address));\n', '    }\n', '}']