['// SPDX-License-Identifier: MIT\n', '/*\n', ' * MIT License\n', ' * ===========\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy\n', ' * of this software and associated documentation files (the "Software"), to deal\n', ' * in the Software without restriction, including without limitation the rights\n', ' * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', ' * copies of the Software, and to permit persons to whom the Software is\n', ' * furnished to do so, subject to the following conditions:\n', ' *\n', ' * The above copyright notice and this permission notice shall be included in all\n', ' * copies or substantial portions of the Software.\n', ' *\n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', ' */\n', 'pragma solidity 0.7.6;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./Permissions.sol";\n', 'import "./Withdrawable.sol";\n', 'import "./IPENDLE.sol";\n', 'import "./IPendleTokenDistribution.sol";\n', '\n', '// There will be two instances of this contract to be deployed to be\n', '// the pendleTeamTokens and pendleEcosystemFund (for PENDLE.sol constructor arguments)\n', 'contract PendleTokenDistribution is Permissions, IPendleTokenDistribution {\n', '    using SafeMath for uint256;\n', '\n', '    IPENDLE public override pendleToken;\n', '\n', '    uint256[] public timeDurations;\n', '    uint256[] public claimableFunds;\n', '    mapping(uint256 => bool) public claimed;\n', '    uint256 public numberOfDurations;\n', '\n', '    constructor(\n', '        address _governance,\n', '        uint256[] memory _timeDurations,\n', '        uint256[] memory _claimableFunds\n', '    ) Permissions(_governance) {\n', '        require(_timeDurations.length == _claimableFunds.length, "MISMATCH_ARRAY_LENGTH");\n', '        numberOfDurations = _timeDurations.length;\n', '        for (uint256 i = 0; i < numberOfDurations; i++) {\n', '            timeDurations.push(_timeDurations[i]);\n', '            claimableFunds.push(_claimableFunds[i]);\n', '        }\n', '    }\n', '\n', '    function initialize(IPENDLE _pendleToken) external {\n', '        require(msg.sender == initializer, "FORBIDDEN");\n', '        require(address(_pendleToken) != address(0), "ZERO_ADDRESS");\n', '        require(_pendleToken.isPendleToken(), "INVALID_PENDLE_TOKEN");\n', '        require(_pendleToken.balanceOf(address(this)) > 0, "UNDISTRIBUTED_PENDLE_TOKEN");\n', '        pendleToken = _pendleToken;\n', '        initializer = address(0);\n', '    }\n', '\n', '    function claimTokens(uint256 timeDurationIndex) public onlyGovernance {\n', '        require(timeDurationIndex < numberOfDurations, "INVALID_INDEX");\n', '        require(!claimed[timeDurationIndex], "ALREADY_CLAIMED");\n', '        claimed[timeDurationIndex] = true;\n', '\n', '        uint256 claimableTimestamp = pendleToken.startTime().add(timeDurations[timeDurationIndex]);\n', '        require(block.timestamp >= claimableTimestamp, "NOT_CLAIMABLE_YET");\n', '        uint256 currentPendleBalance = pendleToken.balanceOf(address(this));\n', '\n', '        uint256 amount =\n', '            claimableFunds[timeDurationIndex] < currentPendleBalance\n', '                ? claimableFunds[timeDurationIndex]\n', '                : currentPendleBalance;\n', '        require(pendleToken.transfer(governance, amount), "FAIL_PENDLE_TRANSFER");\n', '        emit ClaimedTokens(\n', '            governance,\n', '            timeDurations[timeDurationIndex],\n', '            claimableFunds[timeDurationIndex],\n', '            amount\n', '        );\n', '    }\n', '}']