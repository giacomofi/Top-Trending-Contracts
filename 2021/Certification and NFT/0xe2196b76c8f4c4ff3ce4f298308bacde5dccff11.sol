['// SPDX-License-Identifier: UNLICENSED\n', '// https://spdx.org/licenses/\n', '\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./_Ownable_.sol";\n', 'import "./_OpenClose.sol";\n', 'import "./_Guest_.sol";\n', '\n', '/*\n', '    caution\n', '    compiler    : 0.6.12\n', '    language    : solidity\n', '    evm version : petersburg / homestead ?\n', '    enable optimization 200\n', '*/\n', '\n', 'contract Lottery is _Ownable_, _OpenClose, _Guest_{\n', '    uint32 public constant version = 20210128;\n', '\n', '    // Required function\n', '    receive()   external payable{/* require(msg.data.length == 0); */}\n', '    fallback()  external payable{/* require(msg.data.length == 0); */}\n', ' \n', '    constructor() public {\n', '        _owner = msg.sender;\n', '\n', '        $global.accumulationRate   = 70; // 70   : 70%\n', '\n', '        // unit : K, 500 => 500 * 1000\n', '        $config[0].guestLimits  =   1;\n', '        $config[1].guestLimits  =   1;\n', '        $config[2].guestLimits  =   1;\n', '\n', '        // fix 0.01 ether(10 finney)\n', '        $config[0].slotPrice    = 10 finney;\n', '        $config[1].slotPrice    = 10 finney;\n', '        $config[2].slotPrice    = 10 finney;\n', '\n', '        $global.findPage     = 1000;\n', '\n', '        // Initialization fresh start\n', '        $STATE memory c;\n', '        $_state[0]             = c;\n', '        $_state[0].progressStep= $PROGRESS.Opened_ReadyToTimeout;  // ReadyToOpen:0 -> set 1\n', '        $_state[0].dateStart   = uint32(block.timestamp);\n', '        $_state[0].turn        = 1;\n', '        $_state[1]             = c;\n', '        $_state[1].progressStep= $PROGRESS.Opened_ReadyToTimeout;  // ReadyToOpen:0 -> set 1\n', '        $_state[1].dateStart   = uint32(block.timestamp);\n', '        $_state[1].turn        = 1;\n', '        $_state[2]             = c;\n', '        $_state[2].progressStep= $PROGRESS.Opened_ReadyToTimeout;  // ReadyToOpen:0 -> set 1\n', '        $_state[2].dateStart   = uint32(block.timestamp);\n', '        $_state[2].turn        = 1;\n', '    }\n', '\n', '    function boardState() external view onlyOwner returns(\n', '        uint[3] memory amounts // amount35, amount40, amount45,\n', '        ){\n', '        amounts[0] = $_state[0].fullAmounts / 1 finney;\n', '        amounts[1] = $_state[1].fullAmounts / 1 finney;\n', '        amounts[2] = $_state[2].fullAmounts / 1 finney;\n', '    }\n', '\n', '    function boardClosed()external view onlyOwner returns(LASTGAME memory l35, LASTGAME memory l40, LASTGAME memory l45){\n', '        l35 = _lastgame[0];\n', '        l40 = _lastgame[1];\n', '        l45 = _lastgame[2];\n', '    }\n', '    \n', '    struct $PROGRESSES{\n', '        // open/close\n', '        uint24      turn;\n', '        bool        isRunning;\n', '        $PROGRESS   progress;\n', '        // accumulated\n', '        uint        accumulated;\n', '        // guest\n', '        uint        guestLimits;\n', '        uint        guestCounts;\n', '        // timeout\n', '        uint32      timeStart;\n', '        uint32      timeoutUntil;\n', '        // find seek\n', '        uint        seekPosition;\n', '    }\n', '    function lookupProgress() external view onlyOwner returns($PROGRESSES[3] memory progress){\n', '        for(uint8 c = 0; c < 3; c++){\n', '            progress[c].turn            = $_state[c].turn;\n', '            progress[c].progress        = $_state[c].progressStep;\n', '            progress[c].isRunning       = ($_state[c].progressStep == $PROGRESS.Opened_ReadyToTimeout || $_state[c].progressStep == $PROGRESS.Timeout_ReadyToClose);\n', '            progress[c].accumulated     = $_state[c].fullAmounts / 100 * $global.accumulationRate;\n', '            progress[c].guestLimits     = $config[c].guestLimits;\n', '            progress[c].guestCounts     = $guests[c].lists.length;\n', '            progress[c].timeStart       = $_state[c].dateStart;\n', '            progress[c].timeoutUntil    = $_state[c].dateExpiry;\n', '            progress[c].seekPosition    = $seekPosition[c];\n', '        }\n', '    }\n', '\n', '    function paymentWaitingList() external view onlyOwner returns(WINNER[] memory waiting, WINNER[] memory withdraw){\n', '        return (_waitingList,_withdrawedList);\n', '    }\n', '\n', '    function paymentWithdraw() external onlyOwner{\n', '        require(_waitingList.length > 0);\n', '\n', '        WINNER memory winner;\n', '        winner = _waitingList[_waitingList.length - 1];\n', '        \n', '        address self = address(this);\n', '        uint balance = self.balance;\n', '        require(balance > winner.toBePaid);\n', '\n', '        //payable(winner.wallet).transfer(winner.toBePaid);\n', '        (bool success, ) = payable(winner.guest.wallet).call{value:winner.toBePaid}("");\n', '        require(success, "Transfer failed.");\n', '\n', '        winner.datetime = uint32(block.timestamp);//now\n', '        _waitingList.pop(); // remove last item\n', '        _withdrawedList.push(winner);\n', '    }\n', '    function clearWithdraw() external onlyOwner{\n', '        delete _withdrawedList;\n', '    }\n', '\n', '// [ ■■■ private utilities ■■■ \n', '// ] ■■■ private utilities ■■■ \n', '\n', '// [ ■■■ test code ■■■ \n', '// ] ■■■ test code ■■■ \n', '\n', '// [ ■■■ deprecated ■■■ \n', '// ] ■■■ deprecated ■■■ \n', '\n', '} // ] Lottery']