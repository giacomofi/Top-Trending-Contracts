['pragma solidity ^0.4.21;\n', '// The GNU General Public License v3\n', '// © Musqogees Tech 2018, Redenom ™\n', '\n', '    \n', '// -------------------- SAFE MATH ----------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Basic ERC20 functions\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract manages Owner and Admin rights.\n', '// Owner is Admin by default and can set other Admin\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    address internal admin;\n', '\n', '    // modifier for Owner functions\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    // modifier for Admin functions\n', '    modifier onlyAdmin {\n', '        require(msg.sender == admin || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    event AdminChanged(address indexed _from, address indexed _to);\n', '\n', '    // Constructor\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '        admin = msg.sender;\n', '    }\n', '\n', '    function setAdmin(address newAdmin) public onlyOwner{\n', '        emit AdminChanged(admin, newAdmin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    function showAdmin() public view onlyAdmin returns(address _admin){\n', '        _admin = admin;\n', '        return _admin;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', 'contract Redenom is ERC20Interface, Owned{\n', '    using SafeMath for uint;\n', '    \n', '    //ERC20 params\n', '    string      public name; // ERC20 \n', '    string      public symbol; // ERC20 \n', '    uint        private _totalSupply; // ERC20\n', '    uint        public decimals = 8; // ERC20 \n', '\n', '\n', '    //Redenomination\n', '    uint public round = 1; \n', '    uint public epoch = 1; \n', '\n', '    bool public frozen = false;\n', '\n', '    //dec - sum of every exponent\n', '    uint[8] private dec = [0,0,0,0,0,0,0,0];\n', '    //mul - internal used array for splitting numbers according to round     \n', '    uint[9] private mul = [1,10,100,1000,10000,100000,1000000,10000000,100000000];\n', '    //weight - internal used array (weights of every digit)    \n', '    uint[9] private weight = [uint(0),0,0,0,0,5,10,30,55];\n', '    //current_toadd - After redenominate() it holds an amount to add on each digit.\n', '    uint[9] private current_toadd = [uint(0),0,0,0,0,0,0,0,0];\n', '    \n', '\n', '    //Funds\n', '    uint public total_fund; // All funds for all epochs 1 000 000 NOM\n', '    uint public epoch_fund; // All funds for current epoch 100 000 NOM\n', '    uint public team_fund; // Team Fund 10% of all funds paid\n', '    uint public redenom_dao_fund; // DAO Fund 30% of all funds paid\n', '\n', '    struct Account {\n', '        uint balance;\n', '        uint lastRound; // Last round dividens paid\n', '        uint lastVotedEpoch; // Last epoch user voted\n', '        uint bitmask; \n', '            // 2 - got 0.55... for phone verif.\n', '            // 4 - got 1 for KYC\n', '            // 1024 - banned\n', '            //\n', '            // [2] [4] 8 16 32 64 128 256 512 [1024] ... - free to use\n', '    }\n', '    \n', '    mapping(address=>Account) accounts; \n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    //Redenom special events\n', '    event Redenomination(uint indexed round);\n', '    event Epoch(uint indexed epoch);\n', '    event VotingOn(address indexed initiator);\n', '    event VotingOff(address indexed initiator);\n', '    event Vote(address indexed voter, uint indexed propId, uint voterBalance, uint indexed voteEpoch);\n', '\n', '    function Redenom() public {\n', '        symbol = "NOMT";\n', '        name = "Redenom_test";\n', "        _totalSupply = 0; // total NOM's in the game \n", '\n', '        total_fund = 1000000 * 10**decimals; // 1 000 000.00000000, 1Mt\n', '        epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt\n', '        total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch_fund\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '    // New epoch can be started if:\n', '    // - Current round is 9\n', '    // - Curen epoch < 10\n', '    // - Voting is over\n', '    function StartNewEpoch() public onlyAdmin returns(bool succ){\n', '        require(frozen == false); \n', '        require(round == 9);\n', '        require(epoch < 10);\n', '        require(votingActive == false); \n', '\n', '        dec = [0,0,0,0,0,0,0,0];  \n', '        round = 1;\n', '        epoch++;\n', '\n', '        epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt\n', '        total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch fund\n', '\n', '        delete projects;\n', '\n', '        emit Epoch(epoch);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '\n', '    ///////////////////////////////////////////B A L L O T////////////////////////////////////////////\n', '\n', '    //Is voting active?\n', '    bool public votingActive = false;\n', '\n', '    // Voter requirements:\n', '    modifier onlyVoter {\n', '        require(votingActive == true);\n', '        require(bitmask_check(msg.sender, 4) == true); //passed KYC\n', '        //require((accounts[msg.sender].balance >= 100000000), "must have >= 1 NOM");\n', '        require((accounts[msg.sender].lastVotedEpoch < epoch));\n', '        require(bitmask_check(msg.sender, 1024) == false); // banned == false\n', '        _;\n', '    }\n', '\n', '    // This is a type for a single Project.\n', '    struct Project {\n', '        uint id;   // Project id\n', '        uint votesWeight; // total weight\n', '        bool active; //active status.\n', '    }\n', '\n', '    // A dynamically-sized array of `Project` structs.\n', '    Project[] public projects;\n', '\n', '    // Add prop. with id: _id\n', '    function addProject(uint _id) public onlyAdmin {\n', '        projects.push(Project({\n', '            id: _id,\n', '            votesWeight: 0,\n', '            active: true\n', '        }));\n', '    }\n', '\n', '    // Turns project ON and OFF\n', '    function swapProject(uint _id) public onlyAdmin {\n', '        for (uint p = 0; p < projects.length; p++){\n', '            if(projects[p].id == _id){\n', '                if(projects[p].active == true){\n', '                    projects[p].active = false;\n', '                }else{\n', '                    projects[p].active = true;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    // Returns proj. weight\n', '    function projectWeight(uint _id) public constant returns(uint PW){\n', '        for (uint p = 0; p < projects.length; p++){\n', '            if(projects[p].id == _id){\n', '                return projects[p].votesWeight;\n', '            }\n', '        }\n', '    }\n', '\n', '    // Returns proj. status\n', '    function projectActive(uint _id) public constant returns(bool PA){\n', '        for (uint p = 0; p < projects.length; p++){\n', '            if(projects[p].id == _id){\n', '                return projects[p].active;\n', '            }\n', '        }\n', '    }\n', '\n', '    // Vote for proj. using id: _id\n', '    function vote(uint _id) public onlyVoter returns(bool success){\n', '        require(frozen == false);\n', '\n', '        //todo updateAccount\n', '        for (uint p = 0; p < projects.length; p++){\n', '            if(projects[p].id == _id && projects[p].active == true){\n', '                projects[p].votesWeight += sqrt(accounts[msg.sender].balance);\n', '                accounts[msg.sender].lastVotedEpoch = epoch;\n', '            }\n', '        }\n', '        emit Vote(msg.sender, _id, accounts[msg.sender].balance, epoch);\n', '\n', '        return true;\n', '    }\n', '\n', '    // Shows currently winning proj \n', '    function winningProject() public constant returns (uint _winningProject){\n', '        uint winningVoteWeight = 0;\n', '        for (uint p = 0; p < projects.length; p++) {\n', '            if (projects[p].votesWeight > winningVoteWeight && projects[p].active == true) {\n', '                winningVoteWeight = projects[p].votesWeight;\n', '                _winningProject = projects[p].id;\n', '            }\n', '        }\n', '    }\n', '\n', '    // Activates voting\n', '    // requires round = 9\n', '    function enableVoting() public onlyAdmin returns(bool succ){ \n', '        require(votingActive == false);\n', '        require(frozen == false);\n', '        require(round == 9);\n', '\n', '        votingActive = true;\n', '        emit VotingOn(msg.sender);\n', '        return true;\n', '\n', '    }\n', '\n', '    // Deactivates voting\n', '    function disableVoting() public onlyAdmin returns(bool succ){\n', '        require(votingActive == true);\n', '        require(frozen == false);\n', '        votingActive = false;\n', '\n', '        emit VotingOff(msg.sender);\n', '        return true;\n', '    }\n', '\n', '    // sqrt root func\n', '    function sqrt(uint x) internal pure returns (uint y) {\n', '        uint z = (x + 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '\n', '    ///////////////////////////////////////////B A L L O T////////////////////////////////////////////\n', '\n', '\n', '\n', '\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '    // NOM token emission functions\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '    // Pays 1.00000000 from epoch_fund to KYC-passed user\n', '    // Uses payout(), bitmask_check(), bitmask_add()\n', '    // adds 4 to bitmask\n', '    function pay1(address to) public onlyAdmin returns(bool success){\n', '        require(bitmask_check(to, 4) == false);\n', '        uint new_amount = 100000000;\n', '        payout(to,new_amount);\n', '        bitmask_add(to, 4);\n', '        return true;\n', '    }\n', '\n', '    // Pays .555666XX from epoch_fund to user approved phone;\n', '    // Uses payout(), bitmask_check(), bitmask_add()\n', '    // adds 2 to bitmask\n', '    function pay055(address to) public onlyAdmin returns(bool success){\n', '        require(bitmask_check(to, 2) == false);\n', '        uint new_amount = 55566600 + (block.timestamp%100);       \n', '        payout(to,new_amount);\n', '        bitmask_add(to, 2);\n', '        return true;\n', '    }\n', '\n', '    // Pays .555666XX from epoch_fund to KYC user in new epoch;\n', '    // Uses payout(), bitmask_check(), bitmask_add()\n', '    // adds 2 to bitmask\n', '    function pay055loyal(address to) public onlyAdmin returns(bool success){\n', '        require(epoch > 1);\n', '        require(bitmask_check(to, 4) == true);\n', '        uint new_amount = 55566600 + (block.timestamp%100);       \n', '        payout(to,new_amount);\n', '        return true;\n', '    }\n', '\n', '    // Pays random number from epoch_fund\n', '    // Uses payout()\n', '    function payCustom(address to, uint amount) public onlyOwner returns(bool success){\n', '        payout(to,amount);\n', '        return true;\n', '    }\n', '\n', '    // Pays [amount] of money to [to] account from epoch_fund\n', '    // Counts amount +30% +10%\n', '    // Updating _totalSupply\n', '    // Pays to balance and 2 funds\n', '    // Refreshes dec[]\n', '    // Emits event\n', '    function payout(address to, uint amount) private returns (bool success){\n', '        require(to != address(0));\n', '        require(amount>=current_mul());\n', '        require(bitmask_check(to, 1024) == false); // banned == false\n', '        require(frozen == false); \n', '        \n', '        //Update account balance\n', '        updateAccount(to);\n', '        //fix amount\n', '        uint fixedAmount = fix_amount(amount);\n', '\n', '        renewDec( accounts[to].balance, accounts[to].balance.add(fixedAmount) );\n', '\n', '        uint team_part = (fixedAmount/100)*10;\n', '        uint dao_part = (fixedAmount/100)*30;\n', '        uint total = fixedAmount.add(team_part).add(dao_part);\n', '\n', '        epoch_fund = epoch_fund.sub(total);\n', '        team_fund = team_fund.add(team_part);\n', '        redenom_dao_fund = redenom_dao_fund.add(dao_part);\n', '        accounts[to].balance = accounts[to].balance.add(fixedAmount);\n', '        _totalSupply = _totalSupply.add(total);\n', '\n', '        emit Transfer(address(0), to, fixedAmount);\n', '        return true;\n', '    }\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', '\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '    // Withdraw amount from team_fund to given address\n', '    function withdraw_team_fund(address to, uint amount) public onlyOwner returns(bool success){\n', '        require(amount <= team_fund);\n', '        accounts[to].balance = accounts[to].balance.add(amount);\n', '        team_fund = team_fund.sub(amount);\n', '        return true;\n', '    }\n', '    // Withdraw amount from redenom_dao_fund to given address\n', '    function withdraw_dao_fund(address to, uint amount) public onlyOwner returns(bool success){\n', '        require(amount <= redenom_dao_fund);\n', '        accounts[to].balance = accounts[to].balance.add(amount);\n', '        redenom_dao_fund = redenom_dao_fund.sub(amount);\n', '        return true;\n', '    }\n', '\n', '    function freeze_contract() public onlyOwner returns(bool success){\n', '        require(frozen == false);\n', '        frozen = true;\n', '        return true;\n', '    }\n', '    function unfreeze_contract() public onlyOwner returns(bool success){\n', '        require(frozen == true);\n', '        frozen = false;\n', '        return true;\n', '    }\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '\n', '    // Run this on every change of user balance\n', '    // Refreshes dec[] array\n', '    // Takes initial and new ammount\n', '    // while transaction must be called for each acc.\n', '    function renewDec(uint initSum, uint newSum) internal returns(bool success){\n', '\n', '        if(round < 9){\n', '            uint tempInitSum = initSum; \n', '            uint tempNewSum = newSum; \n', '            uint cnt = 1;\n', '\n', '            while( (tempNewSum > 0 || tempInitSum > 0) && cnt <= decimals ){\n', '\n', '                uint lastInitSum = tempInitSum%10; // 0.0000000 (0)\n', '                tempInitSum = tempInitSum/10; // (0.0000000) 0\n', '\n', '                uint lastNewSum = tempNewSum%10; // 1.5556664 (5)\n', '                tempNewSum = tempNewSum/10; // (1.5556664) 5\n', '\n', '                if(cnt >= round){\n', '                    if(lastNewSum >= lastInitSum){\n', '                        // If new is bigger\n', '                        dec[decimals-cnt] = dec[decimals-cnt].add(lastNewSum - lastInitSum);\n', '                    }else{\n', '                        // If new is smaller\n', '                        dec[decimals-cnt] = dec[decimals-cnt].sub(lastInitSum - lastNewSum);\n', '                    }\n', '                }\n', '\n', '                cnt = cnt+1;\n', '            }\n', '        }//if(round < 9){\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    ////////////////////////////////////////// BITMASK /////////////////////////////////////////////////////\n', '    // Adding bit to bitmask\n', '    // checks if already set\n', '    function bitmask_add(address user, uint _bit) internal returns(bool success){ //todo privat?\n', '        require(bitmask_check(user, _bit) == false);\n', '        accounts[user].bitmask = accounts[user].bitmask.add(_bit);\n', '        return true;\n', '    }\n', '    // Removes bit from bitmask\n', '    // checks if already set\n', '    function bitmask_rm(address user, uint _bit) internal returns(bool success){\n', '        require(bitmask_check(user, _bit) == true);\n', '        accounts[user].bitmask = accounts[user].bitmask.sub(_bit);\n', '        return true;\n', '    }\n', '    // Checks whether some bit is present in BM\n', '    function bitmask_check(address user, uint _bit) internal view returns (bool status){\n', '        bool flag;\n', '        accounts[user].bitmask & _bit == 0 ? flag = false : flag = true;\n', '        return flag;\n', '    }\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '    function ban_user(address user) public onlyAdmin returns(bool success){\n', '        bitmask_add(user, 1024);\n', '        return true;\n', '    }\n', '    function unban_user(address user) public onlyAdmin returns(bool success){\n', '        bitmask_rm(user, 1024);\n', '        return true;\n', '    }\n', '    function is_banned(address user) public view onlyAdmin returns (bool result){\n', '        return bitmask_check(user, 1024);\n', '    }\n', '    ///////////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', '    //Redenominates \n', '    function redenominate() public onlyAdmin returns(uint current_round){\n', '        require(frozen == false); \n', '        require(round<9); // Round must be < 9\n', '\n', '        // Deleting funds rest from TS\n', '        _totalSupply = _totalSupply.sub( team_fund%mul[round] ).sub( redenom_dao_fund%mul[round] ).sub( dec[8-round]*mul[round-1] );\n', '\n', '        // Redenominating 3 vars: _totalSupply team_fund redenom_dao_fund\n', '        _totalSupply = ( _totalSupply / mul[round] ) * mul[round];\n', '        team_fund = ( team_fund / mul[round] ) * mul[round]; // Redenominates team_fund\n', '        redenom_dao_fund = ( redenom_dao_fund / mul[round] ) * mul[round]; // Redenominates redenom_dao_fund\n', '\n', '        if(round>1){\n', '            // decimals burned in last round and not distributed\n', '            uint superold = dec[(8-round)+1]; \n', '\n', '            // Returning them to epoch_fund\n', '            epoch_fund = epoch_fund.add(superold * mul[round-2]);\n', '            dec[(8-round)+1] = 0;\n', '        }\n', '\n', '        \n', '        if(round<8){ // if round between 1 and 7 \n', '\n', '            uint unclimed = dec[8-round]; // total sum of burned decimal\n', '            //[23,32,43,34,34,54,34, ->46<- ]\n', '            uint total_current = dec[8-1-round]; // total sum of last active decimal\n', '            //[23,32,43,34,34,54, ->34<-, 46]\n', '\n', '            // security check\n', '            if(total_current==0){\n', '                current_toadd = [0,0,0,0,0,0,0,0,0]; \n', '                round++;\n', '                return round;\n', '            }\n', '\n', '            // Counting amounts to add on every digit\n', '            uint[9] memory numbers  =[uint(1),2,3,4,5,6,7,8,9]; // \n', '            uint[9] memory ke9  =[uint(0),0,0,0,0,0,0,0,0]; // \n', '            uint[9] memory k2e9  =[uint(0),0,0,0,0,0,0,0,0]; // \n', '\n', '            uint k05summ = 0;\n', '\n', '                for (uint k = 0; k < ke9.length; k++) {\n', '                     \n', '                    ke9[k] = numbers[k]*1e9/total_current;\n', '                    if(k<5) k05summ += ke9[k];\n', '                }             \n', '                for (uint k2 = 5; k2 < k2e9.length; k2++) {\n', '                    k2e9[k2] = uint(ke9[k2])+uint(k05summ)*uint(weight[k2])/uint(100);\n', '                }\n', '                for (uint n = 5; n < current_toadd.length; n++) {\n', '                    current_toadd[n] = k2e9[n]*unclimed/10/1e9;\n', '                }\n', '                // current_toadd now contains all digits\n', '                \n', '        }else{\n', '            if(round==8){\n', '                // Returns last burned decimals to epoch_fund\n', '                epoch_fund = epoch_fund.add(dec[0] * 10000000); //1e7\n', '                dec[0] = 0;\n', '            }\n', '            \n', '        }\n', '\n', '        round++;\n', '        emit Redenomination(round);\n', '        return round;\n', '    }\n', '\n', '   \n', '    // Refresh user acc\n', '    // Pays dividends if any\n', '    function updateAccount(address account) public returns(uint new_balance){\n', '        require(frozen == false); \n', '        require(round<=9);\n', '        require(bitmask_check(account, 1024) == false); // banned == false\n', '\n', '        if(round > accounts[account].lastRound){\n', '\n', '            if(round >1 && round <=8){\n', '\n', '\n', '                // Splits user bal by current multiplier\n', '                uint tempDividedBalance = accounts[account].balance/current_mul();\n', '                // [1.5556663] 4  (r2)\n', '                uint newFixedBalance = tempDividedBalance*current_mul();\n', '                // [1.55566630]  (r2)\n', '                uint lastActiveDigit = tempDividedBalance%10;\n', '                 // 1.555666 [3] 4  (r2)\n', '                uint diff = accounts[account].balance - newFixedBalance;\n', '                // 1.5556663 [4] (r2)\n', '\n', '                if(diff > 0){\n', '                    accounts[account].balance = newFixedBalance;\n', '                    emit Transfer(account, address(0), diff);\n', '                }\n', '\n', '                uint toBalance = 0;\n', '                if(lastActiveDigit>0 && current_toadd[lastActiveDigit-1]>0){\n', '                    toBalance = current_toadd[lastActiveDigit-1] * current_mul();\n', '                }\n', '\n', '\n', '                if(toBalance > 0 && toBalance < dec[8-round+1]){ // Not enough\n', '\n', '                    renewDec( accounts[account].balance, accounts[account].balance.add(toBalance) );\n', '                    emit Transfer(address(0), account, toBalance);\n', '                    // Refreshing dec arr\n', '                    accounts[account].balance = accounts[account].balance.add(toBalance);\n', '                    // Adding to ball\n', '                    dec[8-round+1] = dec[8-round+1].sub(toBalance);\n', '                    // Taking from burned decimal\n', '                    _totalSupply = _totalSupply.add(toBalance);\n', '                    // Add dividend to _totalSupply\n', '                }\n', '\n', '                accounts[account].lastRound = round;\n', '                // Writting last round in wich user got dividends\n', '                return accounts[account].balance;\n', '                // returns new balance\n', '            }else{\n', '                if( round == 9){ //100000000 = 9 mul (mul8)\n', '\n', '                    uint newBalance = fix_amount(accounts[account].balance);\n', '                    uint _diff = accounts[account].balance.sub(newBalance);\n', '\n', '                    if(_diff > 0){\n', '                        renewDec( accounts[account].balance, newBalance );\n', '                        accounts[account].balance = newBalance;\n', '                        emit Transfer(account, address(0), _diff);\n', '                    }\n', '\n', '                    accounts[account].lastRound = round;\n', '                    // Writting last round in wich user got dividends\n', '                    return accounts[account].balance;\n', '                    // returns new balance\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    // Returns current multipl. based on round\n', '    // Returns current multiplier based on round\n', '    function current_mul() internal view returns(uint _current_mul){\n', '        return mul[round-1];\n', '    }\n', '    // Removes burned values 123 -> 120  \n', '    // Returns fixed\n', '    function fix_amount(uint amount) public view returns(uint fixed_amount){\n', '        return ( amount / current_mul() ) * current_mul();\n', '    }\n', '    // Returns rest\n', '    function get_rest(uint amount) internal view returns(uint fixed_amount){\n', '        return amount % current_mul();\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 totalSupply: \n', '    //-------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 balanceOf: Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return accounts[tokenOwner].balance;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 allowance:\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 transfer:\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(frozen == false); \n', '        require(to != address(0));\n', '        require(bitmask_check(to, 1024) == false); // banned == false\n', '\n', '        //Fixing amount, deleting burned decimals\n', '        tokens = fix_amount(tokens);\n', '        // Checking if greater then 0\n', '        require(tokens>0);\n', '\n', '        //Refreshing accs, payng dividends\n', '        updateAccount(to);\n', '        updateAccount(msg.sender);\n', '\n', '        uint fromOldBal = accounts[msg.sender].balance;\n', '        uint toOldBal = accounts[to].balance;\n', '\n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);\n', '        accounts[to].balance = accounts[to].balance.add(tokens);\n', '\n', '        require(renewDec(fromOldBal, accounts[msg.sender].balance));\n', '        require(renewDec(toOldBal, accounts[to].balance));\n', '\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 approve:\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        require(frozen == false); \n', '        require(bitmask_check(msg.sender, 1024) == false); // banned == false\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 transferFrom:\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(frozen == false); \n', '        require(bitmask_check(to, 1024) == false); // banned == false\n', '        updateAccount(from);\n', '        updateAccount(to);\n', '\n', '        uint fromOldBal = accounts[from].balance;\n', '        uint toOldBal = accounts[to].balance;\n', '\n', '        accounts[from].balance = accounts[from].balance.sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        accounts[to].balance = accounts[to].balance.add(tokens);\n', '\n', '        require(renewDec(fromOldBal, accounts[from].balance));\n', '        require(renewDec(toOldBal, accounts[to].balance));\n', '\n', '        emit Transfer(from, to, tokens);\n', '        return true; \n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        require(frozen == false); \n', '        require(bitmask_check(msg.sender, 1024) == false); // banned == false\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH https://github.com/ConsenSys/Ethereum-Development-Best-Practices/wiki/Fallback-functions-and-the-fundamental-limitations-of-using-send()-in-Ethereum-&-Solidity\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    } // OR function() payable { } to accept ETH \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        require(frozen == false); \n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '\n', '\n', '\n', '} // © Musqogees Tech 2018, Redenom ™']