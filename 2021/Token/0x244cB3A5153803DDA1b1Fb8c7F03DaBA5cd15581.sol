['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.8.3;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "./TokenLockup.sol";\n', '\n', 'contract BatchTransfer {\n', '    function batchTransfer(IERC20 token,\n', '        address[] memory recipients,\n', '        uint[] memory amounts) external returns (bool) {\n', '\n', '        require(recipients.length == amounts.length, "recipient & amount arrays must be the same length");\n', '\n', '        for (uint i; i < recipients.length; i++) {\n', '            require(token.transferFrom(msg.sender, recipients[i], amounts[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "./ScheduleCalc.sol";\n', '\n', '// interface with ERC20 and the burn function interface from the associated Token contract\n', 'interface IERC20Burnable is IERC20 {\n', '    function burn(uint256 amount) external;\n', '\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', 'contract TokenLockup {\n', '    IERC20Burnable public token;\n', '    string private _name;\n', '    string private _symbol;\n', '\n', '    ReleaseSchedule[] public releaseSchedules;\n', '    uint public minReleaseScheduleAmount;\n', '    uint public maxReleaseDelay;\n', '\n', '    mapping(address => Timelock[]) public timelocks;\n', '    mapping(address => uint) internal _totalTokensUnlocked;\n', '    mapping(address => mapping(address => uint)) internal _allowances;\n', '\n', '    event Approval(address indexed from, address indexed spender, uint amount);\n', '    event TimelockBurned(address indexed from, uint timelockId);\n', '    event ScheduleCreated(address indexed from, uint scheduleId);\n', '    event ScheduleFunded(address indexed from, address indexed to, uint indexed scheduleId, uint amount, uint commencementTimestamp, uint timelockId);\n', '\n', '    /*  The constructor that specifies the token, name and symbol\n', '        The name should specify that it is an unlock contract\n', '        The symbol should end with " Unlock" & be less than 11 characters for MetaMask "custom token" compatibility\n', '    */\n', '    constructor (\n', '        address _token,\n', '        string memory name_,\n', '        string memory symbol_,\n', '        uint _minReleaseScheduleAmount,\n', '        uint _maxReleaseDelay\n', '    ) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '        token = IERC20Burnable(_token);\n', '\n', '        require(_minReleaseScheduleAmount > 0, "Min schedule amount > 0");\n', '        minReleaseScheduleAmount = _minReleaseScheduleAmount;\n', '        maxReleaseDelay = _maxReleaseDelay;\n', '    }\n', '\n', '    function createReleaseSchedule(\n', '        uint releaseCount, // total number of releases including any initial "cliff\'\n', '        uint delayUntilFirstReleaseInSeconds, // "cliff" or 0 for immediate relase\n', '        uint initialReleasePortionInBips, // in 100ths of 1%\n', '        uint periodBetweenReleasesInSeconds\n', '    )\n', '    external\n', '    returns\n', '    (\n', '        uint unlockScheduleId\n', '    ) {\n', '        require(delayUntilFirstReleaseInSeconds <= maxReleaseDelay, "first release > max");\n', '\n', '        require(releaseCount >= 1, "< 1 release");\n', '        require(initialReleasePortionInBips <= ScheduleCalc.BIPS_PRECISION, "release > 100%");\n', '        if (releaseCount > 1) {\n', '            require(periodBetweenReleasesInSeconds > 0, "period = 0");\n', '        }\n', '        if (releaseCount == 1) {\n', '            require(initialReleasePortionInBips == ScheduleCalc.BIPS_PRECISION, "released < 100%");\n', '        }\n', '\n', '        releaseSchedules.push(ReleaseSchedule(\n', '                releaseCount,\n', '                delayUntilFirstReleaseInSeconds,\n', '                initialReleasePortionInBips,\n', '                periodBetweenReleasesInSeconds\n', '            ));\n', '\n', '        emit ScheduleCreated(msg.sender, unlockScheduleId);\n', '        // returning the index of the newly added schedule\n', '        return releaseSchedules.length - 1;\n', '    }\n', '\n', '    function fundReleaseSchedule(\n', '        address to,\n', '        uint amount,\n', '        uint commencementTimestamp, // unix timestamp\n', '        uint scheduleId\n', '    ) public returns(bool) {\n', '        require(amount >= minReleaseScheduleAmount, "amount < min funding");\n', '        require(to != address(0), "to 0 address");\n', '        require(scheduleId < releaseSchedules.length, "bad scheduleId");\n', '        require(amount >= releaseSchedules[scheduleId].releaseCount, "< 1 token per release");\n', "        // It will revert via ERC20 implementation if there's no allowance\n", '        require(token.transferFrom(msg.sender, address(this), amount));\n', '        require(\n', '            commencementTimestamp <= block.timestamp + maxReleaseDelay\n', '        , "commencement time out of range");\n', '\n', '        require(\n', '            commencementTimestamp + releaseSchedules[scheduleId].delayUntilFirstReleaseInSeconds  <=\n', '            block.timestamp + maxReleaseDelay\n', '        , "initial release out of range");\n', '\n', '        Timelock memory timelock;\n', '        timelock.scheduleId = scheduleId;\n', '        timelock.commencementTimestamp = commencementTimestamp;\n', '        timelock.totalAmount = amount;\n', '\n', '        timelocks[to].push(timelock);\n', '\n', '        emit ScheduleFunded(msg.sender, to, scheduleId, amount, commencementTimestamp, timelocks[to].length - 1);\n', '        return true;\n', '    }\n', '\n', '    function batchFundReleaseSchedule(\n', '        address[] memory recipients,\n', '        uint[] memory amounts,\n', '        uint[] memory commencementTimestamps, // unix timestamp\n', '        uint[] memory scheduleIds\n', '    ) external returns (bool) {\n', '        require(amounts.length == recipients.length, "mismatched array length");\n', '        for (uint i; i < recipients.length; i++) {\n', '            require(fundReleaseSchedule(recipients[i], amounts[i], commencementTimestamps[i], scheduleIds[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function lockedBalanceOf(address who) public view returns (uint amount) {\n', '        for (uint i = 0; i < timelocks[who].length; i++) {\n', '            amount += lockedBalanceOfTimelock(who, i);\n', '        }\n', '        return amount;\n', '    }\n', '\n', '    function unlockedBalanceOf(address who) public view returns (uint amount) {\n', '        for (uint i = 0; i < timelocks[who].length; i++) {\n', '            amount += unlockedBalanceOfTimelock(who, i);\n', '        }\n', '        return amount;\n', '    }\n', '\n', '    function lockedBalanceOfTimelock(address who, uint timelockIndex) public view returns (uint locked) {\n', '        return timelocks[who][timelockIndex].totalAmount - totalUnlockedToDateOfTimelock(who, timelockIndex);\n', '    }\n', '\n', '    function unlockedBalanceOfTimelock(address who, uint timelockIndex) public view returns (uint unlocked) {\n', '        return totalUnlockedToDateOfTimelock(who, timelockIndex) - timelocks[who][timelockIndex].tokensTransferred;\n', '    }\n', '\n', '    function totalUnlockedToDateOfTimelock(address who, uint timelockIndex) public view returns (uint unlocked) {\n', '        return calculateUnlocked(\n', '            timelocks[who][timelockIndex].commencementTimestamp,\n', '            block.timestamp,\n', '            timelocks[who][timelockIndex].totalAmount,\n', '            timelocks[who][timelockIndex].scheduleId\n', '        );\n', '    }\n', '\n', '    function viewTimelock(address who, uint256 index) public view\n', '    returns (Timelock memory timelock) {\n', '        return timelocks[who][index];\n', '    }\n', '\n', '    function balanceOf(address who) external view returns (uint) {\n', '        return unlockedBalanceOf(who) + lockedBalanceOf(who);\n', '    }\n', '\n', '    function transfer(address to, uint value) external returns (bool) {\n', '        return _transfer(msg.sender, to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint value) external returns (bool) {\n', '        require(_allowances[from][msg.sender] >= value, "value > allowance");\n', '        _allowances[from][msg.sender] -= value;\n', '        return _transfer(from, to, value);\n', '    }\n', '\n', "    // Code from OpenZeppelin's contract/token/ERC20/ERC20.sol, modified\n", '    function approve(address spender, uint amount) external returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', "    // Code from OpenZeppelin's contract/token/ERC20/ERC20.sol, modified\n", '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', "    // Code from OpenZeppelin's contract/token/ERC20/ERC20.sol, modified\n", '    function increaseAllowance(address spender, uint addedValue) external returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);\n', '        return true;\n', '    }\n', '\n', "    // Code from OpenZeppelin's contract/token/ERC20/ERC20.sol, modified\n", '    function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {\n', '        uint currentAllowance = _allowances[msg.sender][spender];\n', '        require(currentAllowance >= subtractedValue, "decrease > allowance");\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);\n', '        return true;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return token.decimals();\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function totalSupply() external view returns (uint) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    function burn(uint timelockIndex, uint confirmationIdPlusOne) external returns(bool) {\n', '        require(timelockIndex < timelocks[msg.sender].length, "No schedule");\n', '\n', '        // this also protects from overflow below\n', '        require(confirmationIdPlusOne == timelockIndex + 1, "Burn not confirmed");\n', '\n', '        // actually burning the remaining tokens from the unlock\n', '        token.burn(lockedBalanceOfTimelock(msg.sender, timelockIndex) + unlockedBalanceOfTimelock(msg.sender, timelockIndex));\n', '\n', '        // overwrite the timelock to delete with the timelock on the end which will be discarded\n', '        // if the timelock to delete is on the end, it will just be deleted in the step after the if statement\n', '        if (timelocks[msg.sender].length - 1 != timelockIndex) {\n', '            timelocks[msg.sender][timelockIndex] = timelocks[msg.sender][timelocks[msg.sender].length - 1];\n', '        }\n', '        // delete the timelock on the end\n', '        timelocks[msg.sender].pop();\n', '\n', '        emit TimelockBurned(msg.sender, timelockIndex);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address from, address to, uint value) internal returns (bool) {\n', '        require(unlockedBalanceOf(from) >= value, "amount > unlocked");\n', '\n', '        uint remainingTransfer = value;\n', '\n', '        // transfer from unlocked tokens\n', '        for (uint i = 0; i < timelocks[from].length; i++) {\n', '            // if the timelock has no value left\n', '            if (timelocks[from][i].tokensTransferred == timelocks[from][i].totalAmount) {\n', '                continue;\n', '            } else if (remainingTransfer > unlockedBalanceOfTimelock(from, i)) {\n', '                // if the remainingTransfer is more than the unlocked balance use it all\n', '                remainingTransfer -= unlockedBalanceOfTimelock(from, i);\n', '                timelocks[from][i].tokensTransferred += unlockedBalanceOfTimelock(from, i);\n', '            } else {\n', '                // if the remainingTransfer is less than or equal to the unlocked balance\n', '                // use part or all and exit the loop\n', '                timelocks[from][i].tokensTransferred += remainingTransfer;\n', '                remainingTransfer = 0;\n', '                break;\n', '            }\n', '        }\n', '\n', '        // should never have a remainingTransfer amount at this point\n', '        require(remainingTransfer == 0, "bad transfer");\n', '\n', '        require(token.transfer(to, value));\n', '        return true;\n', '    }\n', '\n', '    function transferTimelock(address to, uint value, uint timelockId) external returns (bool) {\n', '        require(unlockedBalanceOfTimelock(msg.sender, timelockId) >= value, "amount > unlocked");\n', '        timelocks[msg.sender][timelockId].tokensTransferred += value;\n', '        require(token.transfer(to, value));\n', '        return true;\n', '    }\n', '\n', '    function calculateUnlocked(uint commencedTimestamp, uint currentTimestamp, uint amount, uint scheduleId) public view returns (uint unlocked) {\n', '        return ScheduleCalc.calculateUnlocked(commencedTimestamp, currentTimestamp, amount, releaseSchedules[scheduleId]);\n', '    }\n', '\n', "    // Code from OpenZeppelin's contract/token/ERC20/ERC20.sol, modified\n", '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0));\n', '        require(spender != address(0), "spender is 0 address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function scheduleCount() external view returns (uint count) {\n', '        return releaseSchedules.length;\n', '    }\n', '\n', '    function timelockOf(address who, uint index) external view returns (Timelock memory timelock) {\n', '        return timelocks[who][index];\n', '    }\n', '\n', '    function timelockCountOf(address who) external view returns (uint) {\n', '        return timelocks[who].length;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'struct ReleaseSchedule {\n', '    uint releaseCount;\n', '    uint delayUntilFirstReleaseInSeconds;\n', '    uint initialReleasePortionInBips;\n', '    uint periodBetweenReleasesInSeconds;\n', '}\n', '\n', 'struct Timelock {\n', '    uint scheduleId;\n', '    uint commencementTimestamp;\n', '    uint tokensTransferred;\n', '    uint totalAmount;\n', '}\n', '\n', 'library ScheduleCalc {\n', '    uint constant BIPS_PRECISION = 10000;\n', '\n', '    function calculateUnlocked(uint commencedTimestamp, uint currentTimestamp, uint amount, ReleaseSchedule memory releaseSchedule) external pure returns (uint unlocked) {\n', '        if(commencedTimestamp > currentTimestamp) {\n', '            return 0;\n', '        }\n', '        uint secondsElapsed = currentTimestamp - commencedTimestamp;\n', '\n', '        // return the full amount if the total lockup period has expired\n', '        // unlocked amounts in each period are truncated and round down remainders smaller than the smallest unit\n', '        // unlocking the full amount unlocks any remainder amounts in the final unlock period\n', '        // this is done first to reduce computation\n', '        if (secondsElapsed >= releaseSchedule.delayUntilFirstReleaseInSeconds +\n', '        (releaseSchedule.periodBetweenReleasesInSeconds * (releaseSchedule.releaseCount - 1))) {\n', '            return amount;\n', '        }\n', '\n', '        // unlock the initial release if the delay has elapsed\n', '        if (secondsElapsed >= releaseSchedule.delayUntilFirstReleaseInSeconds) {\n', '            unlocked = (amount * releaseSchedule.initialReleasePortionInBips) / BIPS_PRECISION;\n', '\n', '            // if at least one period after the delay has passed\n', '            if (secondsElapsed - releaseSchedule.delayUntilFirstReleaseInSeconds\n', '                >= releaseSchedule.periodBetweenReleasesInSeconds) {\n', '\n', '                // calculate the number of additional periods that have passed (not including the initial release)\n', '                // this discards any remainders (ie it truncates / rounds down)\n', '                uint additionalUnlockedPeriods =\n', '                (secondsElapsed - releaseSchedule.delayUntilFirstReleaseInSeconds) /\n', '                releaseSchedule.periodBetweenReleasesInSeconds;\n', '\n', '                // calculate the amount of unlocked tokens for the additionalUnlockedPeriods\n', '                // multiplication is applied before division to delay truncating to the smallest unit\n', '                // this distributes unlocked tokens more evenly across unlock periods\n', '                // than truncated division followed by multiplication\n', '                unlocked += ((amount - unlocked) * additionalUnlockedPeriods) / (releaseSchedule.releaseCount - 1);\n', '            }\n', '        }\n', '\n', '        return unlocked;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']