['contract Consulting {\n', '    /*\n', '     *  This contract accepts payment from clients, and payout to engineer and manager.\n', '     */\n', '    address public engineer;\n', '    address public manager;\n', '    uint public createdTime;\n', '    uint public updatedTime;\n', '\n', '    function Consulting(address _engineer, address _manager) {\n', '        engineer = 0x2207bD0174840f4C728c0B07DE9bDD643Ee2E7d6;\n', '        manager = 0xddd31eb39d56d51b50172884bd2b88e1f6264f95;\n', '        createdTime = block.timestamp;\n', '        updatedTime = block.timestamp;\n', '    }\n', '\n', '    /* Contract payout hald */\n', '    function payout() returns (bool _success) {\n', '        if(msg.sender == engineer || msg.sender == manager) {\n', '             engineer.send(this.balance / 2);\n', '             manager.send(this.balance);\n', '             updatedTime = block.timestamp;\n', '             _success = true;\n', '        }else{\n', '            _success = false;\n', '        }\n', '    }\n', '}']