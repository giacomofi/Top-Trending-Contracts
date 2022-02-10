['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', 'contract SicBo is Owned {\n', '    using SafeMath for uint;\n', '\n', '    uint public LimitBottom = 0.05 ether;\n', '    uint public LimitTop = 0.2 ether;\n', '    \n', '    address public Drawer;\n', '\n', '    struct Game {\n', '        bytes32 Bets;\n', '        bytes32 SecretKey_P;\n', '        bool isPlay;\n', '        bool isPay;\n', '        uint Result;\n', '        uint Time;\n', '        address Buyer;\n', '    }\n', '    \n', '    mapping (bytes32 => Game) public TicketPool;\n', '    \n', '    event SubmitTicket(bytes32 indexed SecretKey_D_hash, uint Bet_amount, bytes32 Bet, bytes32 SecretKey_P, address Player);   \n', '    event Result(bytes32 indexed SecretKey_D_hash, bytes32 indexed SecretKey_D,address indexed Buyer, uint Dice1, uint Dice2, uint Dice3, uint Game_Result, uint time);\n', '    event Pay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);\n', '    event Owe(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);\n', '    event OwePay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);\n', '    \n', '    function SicBo (address drawer_) public {\n', '        Drawer = drawer_;\n', '    }\n', '    \n', '    function submit(bytes32 Bets, bytes32 secretKey_P, bytes32 secretKey_D_hash) payable public {\n', '        \n', '        require(TicketPool[secretKey_D_hash].Time == 0);\n', '        require(msg.value >= LimitBottom && msg.value <= LimitTop);\n', '\n', '        uint  bet_total_amount = 0;\n', '        for (uint i = 0; i < 29; i++) {\n', '            if(Bets[i] == 0x00) continue;\n', '            \n', '            uint bet_amount_ = uint(Bets[i]).mul(10000000000000000);\n', '\n', '            bet_total_amount = bet_total_amount.add(bet_amount_);\n', '        }\n', '        \n', '        if(bet_total_amount == msg.value){\n', '            SubmitTicket(secretKey_D_hash, msg.value, Bets, secretKey_P, msg.sender);\n', '            TicketPool[secretKey_D_hash] = Game(Bets,secretKey_P,false,false,0,block.timestamp,msg.sender);\n', '        }else{\n', '            revert();\n', '        }\n', '        \n', '    }\n', '    \n', '    function award(bytes32 secretKey_D) public {\n', '        \n', '        require(Drawer == msg.sender);\n', '        \n', '        bytes32 secretKey_D_hash = keccak256(secretKey_D);\n', '        \n', '        Game local_ = TicketPool[secretKey_D_hash];\n', '        \n', '        require(local_.Time != 0 && !local_.isPlay);\n', '        \n', '        uint dice1 = uint(keccak256("Pig World ia a Awesome game place", local_.SecretKey_P, secretKey_D)) % 6 + 1;\n', '        uint dice2 = uint(keccak256(secretKey_D, "So you will like us so much!!!!", local_.SecretKey_P)) % 6 + 1;\n', '        uint dice3 = uint(keccak256(local_.SecretKey_P, secretKey_D, "Don&#39;t think this is unfair", "Our game are always provably fair...")) % 6 + 1;\n', '    \n', '        uint amount = 0;\n', '        uint total = dice1 + dice2 + dice3;\n', '        \n', '        for (uint ii = 0; ii < 29; ii++) {\n', '            if(local_.Bets[ii] == 0x00) continue;\n', '            \n', '            uint bet_amount = uint(local_.Bets[ii]) * 10000000000000000;\n', '            \n', '            if(ii >= 23)\n', '                if (dice1 == ii - 22 || dice2 == ii - 22 || dice3 == ii - 22) {\n', '                    uint8 count = 1;\n', '                    if (dice1 == ii - 22) count++;\n', '                    if (dice2 == ii - 22) count++;\n', '                    if (dice3 == ii - 22) count++;\n', '                    amount += count * bet_amount;\n', '                }\n', '\n', '            if(ii <= 8)\n', '                if (dice1 == dice2 && dice2 == dice3 && dice1 == dice3) {\n', '                    if (ii == 8) {\n', '                        amount += 31 * bet_amount;\n', '                    }\n', '    \n', '                    if(ii >= 2 && ii <= 7)\n', '                        if (dice1 == ii - 1) {\n', '                            amount += 181 * bet_amount;\n', '                        }\n', '    \n', '                } else {\n', '                    \n', '                    if (ii == 0 && total <= 10) {\n', '                        amount += 2 * bet_amount;\n', '                    }\n', '                    \n', '                    if (ii == 1 && total >= 11) {\n', '                        amount += 2 * bet_amount;\n', '                    }\n', '                }\n', '                \n', '            if(ii >= 9 && ii <= 22){\n', '                if (ii == 9 && total == 4) {\n', '                    amount += 61 * bet_amount;\n', '                }\n', '                if (ii == 10 && total == 5) {\n', '                    amount += 31 * bet_amount;\n', '                }\n', '                if (ii == 11 && total == 6) {\n', '                    amount += 18 * bet_amount;\n', '                }\n', '                if (ii == 12 && total == 7) {\n', '                    amount += 13 * bet_amount;\n', '                }\n', '                if (ii == 13 && total == 8) {\n', '                    amount += 9 * bet_amount;\n', '                }\n', '                if (ii == 14 && total == 9) {\n', '                    amount += 8 * bet_amount;\n', '                }\n', '                if (ii == 15 && total == 10) {\n', '                    amount += 7 * bet_amount;\n', '                }\n', '                if (ii == 16 && total == 11) {\n', '                    amount += 7 * bet_amount;\n', '                }\n', '                if (ii == 17 && total == 12) {\n', '                    amount += 8 * bet_amount;\n', '                }\n', '                if (ii == 18 && total == 13) {\n', '                    amount += 9 * bet_amount;\n', '                }\n', '                if (ii == 19 && total == 14) {\n', '                    amount += 13 * bet_amount;\n', '                }\n', '                if (ii == 20 && total == 15) {\n', '                    amount += 18 * bet_amount;\n', '                }\n', '                if (ii == 21 && total == 16) {\n', '                    amount += 31 * bet_amount;\n', '                }\n', '                if (ii == 22 && total == 17) {\n', '                    amount += 61 * bet_amount;\n', '                }\n', '            }\n', '        }\n', '        \n', '        Result(secretKey_D_hash, secretKey_D, TicketPool[secretKey_D_hash].Buyer, dice1, dice2, dice3, amount, block.timestamp);\n', '        TicketPool[secretKey_D_hash].isPlay = true;\n', '        \n', '        if(amount != 0){\n', '            TicketPool[secretKey_D_hash].Result = amount;\n', '            if (address(this).balance >= amount && TicketPool[secretKey_D_hash].Buyer.send(amount)) {\n', '                TicketPool[secretKey_D_hash].isPay = true;\n', '                Pay(secretKey_D_hash,TicketPool[secretKey_D_hash].Buyer, amount);\n', '            } else {\n', '                Owe(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, amount);\n', '                TicketPool[secretKey_D_hash].isPay = false;\n', '            } \n', '         } else {\n', '            TicketPool[secretKey_D_hash].isPay = true;\n', '        }\n', '        \n', '    }\n', '    \n', '    function () public payable {\n', '       \n', '    }\n', '    \n', '    function withdraw(uint withdrawEther_) public onlyOwner {\n', '        msg.sender.transfer(withdrawEther_);\n', '    }\n', '    \n', '    function changeLimit(uint _bottom, uint _top) public onlyOwner {\n', '        LimitBottom = _bottom;\n', '        LimitTop = _top;\n', '    }\n', '    \n', '    function changeDrawer(address drawer_) public onlyOwner {\n', '        Drawer = drawer_;\n', '    }\n', '    \n', '    function getisPlay(bytes32 secretKey_D_hash) public constant returns (bool isplay){\n', '        return TicketPool[secretKey_D_hash].isPlay;\n', '    }\n', '    \n', '    function getTicketTime(bytes32 secretKey_D_hash) public constant returns (uint Time){\n', '        return TicketPool[secretKey_D_hash].Time;\n', '    }\n', '    \n', '    function chargeOwe(bytes32 secretKey_D_hash) public {\n', '        require(!TicketPool[secretKey_D_hash].isPay);\n', '        require(TicketPool[secretKey_D_hash].isPlay);\n', '        require(TicketPool[secretKey_D_hash].Result != 0);\n', '        \n', '        if(address(this).balance >= TicketPool[secretKey_D_hash].Result){\n', '            if (TicketPool[secretKey_D_hash].Buyer.send(TicketPool[secretKey_D_hash].Result)) {\n', '                TicketPool[secretKey_D_hash].isPay = true;\n', '                OwePay(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, TicketPool[secretKey_D_hash].Result);\n', '            }\n', '        } \n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', 'contract SicBo is Owned {\n', '    using SafeMath for uint;\n', '\n', '    uint public LimitBottom = 0.05 ether;\n', '    uint public LimitTop = 0.2 ether;\n', '    \n', '    address public Drawer;\n', '\n', '    struct Game {\n', '        bytes32 Bets;\n', '        bytes32 SecretKey_P;\n', '        bool isPlay;\n', '        bool isPay;\n', '        uint Result;\n', '        uint Time;\n', '        address Buyer;\n', '    }\n', '    \n', '    mapping (bytes32 => Game) public TicketPool;\n', '    \n', '    event SubmitTicket(bytes32 indexed SecretKey_D_hash, uint Bet_amount, bytes32 Bet, bytes32 SecretKey_P, address Player);   \n', '    event Result(bytes32 indexed SecretKey_D_hash, bytes32 indexed SecretKey_D,address indexed Buyer, uint Dice1, uint Dice2, uint Dice3, uint Game_Result, uint time);\n', '    event Pay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);\n', '    event Owe(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);\n', '    event OwePay(bytes32 indexed SecretKey_D_hash, address indexed Buyer, uint Game_Result);\n', '    \n', '    function SicBo (address drawer_) public {\n', '        Drawer = drawer_;\n', '    }\n', '    \n', '    function submit(bytes32 Bets, bytes32 secretKey_P, bytes32 secretKey_D_hash) payable public {\n', '        \n', '        require(TicketPool[secretKey_D_hash].Time == 0);\n', '        require(msg.value >= LimitBottom && msg.value <= LimitTop);\n', '\n', '        uint  bet_total_amount = 0;\n', '        for (uint i = 0; i < 29; i++) {\n', '            if(Bets[i] == 0x00) continue;\n', '            \n', '            uint bet_amount_ = uint(Bets[i]).mul(10000000000000000);\n', '\n', '            bet_total_amount = bet_total_amount.add(bet_amount_);\n', '        }\n', '        \n', '        if(bet_total_amount == msg.value){\n', '            SubmitTicket(secretKey_D_hash, msg.value, Bets, secretKey_P, msg.sender);\n', '            TicketPool[secretKey_D_hash] = Game(Bets,secretKey_P,false,false,0,block.timestamp,msg.sender);\n', '        }else{\n', '            revert();\n', '        }\n', '        \n', '    }\n', '    \n', '    function award(bytes32 secretKey_D) public {\n', '        \n', '        require(Drawer == msg.sender);\n', '        \n', '        bytes32 secretKey_D_hash = keccak256(secretKey_D);\n', '        \n', '        Game local_ = TicketPool[secretKey_D_hash];\n', '        \n', '        require(local_.Time != 0 && !local_.isPlay);\n', '        \n', '        uint dice1 = uint(keccak256("Pig World ia a Awesome game place", local_.SecretKey_P, secretKey_D)) % 6 + 1;\n', '        uint dice2 = uint(keccak256(secretKey_D, "So you will like us so much!!!!", local_.SecretKey_P)) % 6 + 1;\n', '        uint dice3 = uint(keccak256(local_.SecretKey_P, secretKey_D, "Don\'t think this is unfair", "Our game are always provably fair...")) % 6 + 1;\n', '    \n', '        uint amount = 0;\n', '        uint total = dice1 + dice2 + dice3;\n', '        \n', '        for (uint ii = 0; ii < 29; ii++) {\n', '            if(local_.Bets[ii] == 0x00) continue;\n', '            \n', '            uint bet_amount = uint(local_.Bets[ii]) * 10000000000000000;\n', '            \n', '            if(ii >= 23)\n', '                if (dice1 == ii - 22 || dice2 == ii - 22 || dice3 == ii - 22) {\n', '                    uint8 count = 1;\n', '                    if (dice1 == ii - 22) count++;\n', '                    if (dice2 == ii - 22) count++;\n', '                    if (dice3 == ii - 22) count++;\n', '                    amount += count * bet_amount;\n', '                }\n', '\n', '            if(ii <= 8)\n', '                if (dice1 == dice2 && dice2 == dice3 && dice1 == dice3) {\n', '                    if (ii == 8) {\n', '                        amount += 31 * bet_amount;\n', '                    }\n', '    \n', '                    if(ii >= 2 && ii <= 7)\n', '                        if (dice1 == ii - 1) {\n', '                            amount += 181 * bet_amount;\n', '                        }\n', '    \n', '                } else {\n', '                    \n', '                    if (ii == 0 && total <= 10) {\n', '                        amount += 2 * bet_amount;\n', '                    }\n', '                    \n', '                    if (ii == 1 && total >= 11) {\n', '                        amount += 2 * bet_amount;\n', '                    }\n', '                }\n', '                \n', '            if(ii >= 9 && ii <= 22){\n', '                if (ii == 9 && total == 4) {\n', '                    amount += 61 * bet_amount;\n', '                }\n', '                if (ii == 10 && total == 5) {\n', '                    amount += 31 * bet_amount;\n', '                }\n', '                if (ii == 11 && total == 6) {\n', '                    amount += 18 * bet_amount;\n', '                }\n', '                if (ii == 12 && total == 7) {\n', '                    amount += 13 * bet_amount;\n', '                }\n', '                if (ii == 13 && total == 8) {\n', '                    amount += 9 * bet_amount;\n', '                }\n', '                if (ii == 14 && total == 9) {\n', '                    amount += 8 * bet_amount;\n', '                }\n', '                if (ii == 15 && total == 10) {\n', '                    amount += 7 * bet_amount;\n', '                }\n', '                if (ii == 16 && total == 11) {\n', '                    amount += 7 * bet_amount;\n', '                }\n', '                if (ii == 17 && total == 12) {\n', '                    amount += 8 * bet_amount;\n', '                }\n', '                if (ii == 18 && total == 13) {\n', '                    amount += 9 * bet_amount;\n', '                }\n', '                if (ii == 19 && total == 14) {\n', '                    amount += 13 * bet_amount;\n', '                }\n', '                if (ii == 20 && total == 15) {\n', '                    amount += 18 * bet_amount;\n', '                }\n', '                if (ii == 21 && total == 16) {\n', '                    amount += 31 * bet_amount;\n', '                }\n', '                if (ii == 22 && total == 17) {\n', '                    amount += 61 * bet_amount;\n', '                }\n', '            }\n', '        }\n', '        \n', '        Result(secretKey_D_hash, secretKey_D, TicketPool[secretKey_D_hash].Buyer, dice1, dice2, dice3, amount, block.timestamp);\n', '        TicketPool[secretKey_D_hash].isPlay = true;\n', '        \n', '        if(amount != 0){\n', '            TicketPool[secretKey_D_hash].Result = amount;\n', '            if (address(this).balance >= amount && TicketPool[secretKey_D_hash].Buyer.send(amount)) {\n', '                TicketPool[secretKey_D_hash].isPay = true;\n', '                Pay(secretKey_D_hash,TicketPool[secretKey_D_hash].Buyer, amount);\n', '            } else {\n', '                Owe(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, amount);\n', '                TicketPool[secretKey_D_hash].isPay = false;\n', '            } \n', '         } else {\n', '            TicketPool[secretKey_D_hash].isPay = true;\n', '        }\n', '        \n', '    }\n', '    \n', '    function () public payable {\n', '       \n', '    }\n', '    \n', '    function withdraw(uint withdrawEther_) public onlyOwner {\n', '        msg.sender.transfer(withdrawEther_);\n', '    }\n', '    \n', '    function changeLimit(uint _bottom, uint _top) public onlyOwner {\n', '        LimitBottom = _bottom;\n', '        LimitTop = _top;\n', '    }\n', '    \n', '    function changeDrawer(address drawer_) public onlyOwner {\n', '        Drawer = drawer_;\n', '    }\n', '    \n', '    function getisPlay(bytes32 secretKey_D_hash) public constant returns (bool isplay){\n', '        return TicketPool[secretKey_D_hash].isPlay;\n', '    }\n', '    \n', '    function getTicketTime(bytes32 secretKey_D_hash) public constant returns (uint Time){\n', '        return TicketPool[secretKey_D_hash].Time;\n', '    }\n', '    \n', '    function chargeOwe(bytes32 secretKey_D_hash) public {\n', '        require(!TicketPool[secretKey_D_hash].isPay);\n', '        require(TicketPool[secretKey_D_hash].isPlay);\n', '        require(TicketPool[secretKey_D_hash].Result != 0);\n', '        \n', '        if(address(this).balance >= TicketPool[secretKey_D_hash].Result){\n', '            if (TicketPool[secretKey_D_hash].Buyer.send(TicketPool[secretKey_D_hash].Result)) {\n', '                TicketPool[secretKey_D_hash].isPay = true;\n', '                OwePay(secretKey_D_hash, TicketPool[secretKey_D_hash].Buyer, TicketPool[secretKey_D_hash].Result);\n', '            }\n', '        } \n', '    }\n', '}']