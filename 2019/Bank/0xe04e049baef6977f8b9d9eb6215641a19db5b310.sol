['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * (E)t)h)e)x) Superprize Contract \n', ' *  This smart-contract is the part of Ethex Lottery fair game.\n', ' *  See latest version at https://github.com/ethex-bet/ethex-lottery \n', ' *  http://ethex.bet\n', ' */\n', ' \n', ' contract EthexSuperprize {\n', '    struct Payout {\n', '        uint256 index;\n', '        uint256 amount;\n', '        uint256 block;\n', '        address payable winnerAddress;\n', '        bytes16 betId;\n', '    }\n', '     \n', '    Payout[] public payouts;\n', '     \n', '    address payable private owner;\n', '    address public lotoAddress;\n', '    address payable public newVersionAddress;\n', '    EthexSuperprize previousContract;\n', '    uint256 public hold;\n', '    \n', '    event Superprize (\n', '        uint256 index,\n', '        uint256 amount,\n', '        address winner,\n', '        bytes16 betId,\n', '        byte state\n', '    );\n', '    \n', '    uint8 constant PARTS = 6;\n', '    uint256 constant PRECISION = 1 ether;\n', '    uint256 constant MONTHLY = 150000;\n', '     \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '     \n', '     modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function() external payable { }\n', '    \n', '    function initSuperprize(address payable winner, bytes16 betId) external {\n', '        require(msg.sender == lotoAddress);\n', '        uint256 amount = address(this).balance - hold;\n', '        hold = address(this).balance;\n', '        uint256 sum;\n', '        uint256 temp;\n', '        for (uint256 i = 1; i < PARTS; i++) {\n', '            temp = amount * PRECISION * (i - 1 + 10) / 75 / PRECISION;\n', '            sum += temp;\n', '            payouts.push(Payout(i, temp, block.number + i * MONTHLY, winner, betId));\n', '        }\n', '        payouts.push(Payout(PARTS, amount - sum, block.number + PARTS * MONTHLY, winner, betId));\n', '        emit Superprize(0, amount, winner, betId, 0);\n', '    }\n', '    \n', '    function paySuperprize() external onlyOwner {\n', '        if (payouts.length == 0)\n', '            return;\n', '        Payout[] memory payoutArray = new Payout[](payouts.length);\n', '        uint i = payouts.length;\n', '        while (i > 0) {\n', '            i--;\n', '            if (payouts[i].block <= block.number) {\n', '                emit Superprize(payouts[i].index, payouts[i].amount, payouts[i].winnerAddress, payouts[i].betId, 0x01);\n', '                hold -= payouts[i].amount;\n', '            }\n', '            payoutArray[i] = payouts[i];\n', '            payouts.pop();\n', '        }\n', '        for (i = 0; i < payoutArray.length; i++)\n', '            if (payoutArray[i].block > block.number)\n', '                payouts.push(payoutArray[i]);\n', '        for (i = 0; i < payoutArray.length; i++)\n', '            if (payoutArray[i].block <= block.number)\n', '                payoutArray[i].winnerAddress.transfer(payoutArray[i].amount);\n', '    }\n', '     \n', '    function setOldVersion(address payable oldAddress) external onlyOwner {\n', '        previousContract = EthexSuperprize(oldAddress);\n', '        lotoAddress = previousContract.lotoAddress();\n', '        hold = previousContract.hold();\n', '        uint256 index;\n', '        uint256 amount;\n', '        uint256 betBlock;\n', '        address payable winner;\n', '        bytes16 betId;\n', '        for (uint i = 0; i < previousContract.getPayoutsCount(); i++) {\n', '            (index, amount, betBlock, winner, betId) = previousContract.payouts(i);\n', '            payouts.push(Payout(index, amount, betBlock, winner, betId));\n', '        }\n', '        previousContract.migrate();\n', '    }\n', '    \n', '    function setNewVersion(address payable newVersion) external onlyOwner {\n', '        newVersionAddress = newVersion;\n', '    }\n', '    \n', '    function setLoto(address loto) external onlyOwner {\n', '        lotoAddress = loto;\n', '    }\n', '    \n', '    function migrate() external {\n', '        require(msg.sender == owner || msg.sender == newVersionAddress);\n', '        require(newVersionAddress != address(0));\n', '        newVersionAddress.transfer(address(this).balance);\n', '    }   \n', '\n', '    function getPayoutsCount() view public returns (uint256) {\n', '        return payouts.length;\n', '    }\n', '}']