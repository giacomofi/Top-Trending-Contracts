['pragma solidity ^0.4.21;\n', '\n', '// Project: MOBU.io\n', '// v12, 2018-08-24\n', '// This code is the property of CryptoB2B.io\n', '// Copying in whole or in part is prohibited.\n', '// Authors: Ivan Fedorov and Dmitry Borodin\n', '// Do you want the same TokenSale platform? www.cryptob2b.io\n', '\n', 'contract IFinancialStrategy{\n', '\n', '    enum State { Active, Refunding, Closed }\n', '    State public state = State.Active;\n', '\n', '    event Deposited(address indexed beneficiary, uint256 weiAmount);\n', '    event Receive(address indexed beneficiary, uint256 weiAmount);\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '    event Started();\n', '    event Closed();\n', '    event RefundsEnabled();\n', '    function freeCash() view public returns(uint256);\n', '    function deposit(address _beneficiary) external payable;\n', '    function refund(address _investor) external;\n', '    function setup(uint8 _state, bytes32[] _params) external;\n', '    function getBeneficiaryCash() external;\n', '    function getPartnerCash(uint8 _user, address _msgsender) external;\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    function minus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (b>=a) return 0;\n', '        return a - b;\n', '    }\n', '}\n', '\n', 'contract IRightAndRoles {\n', '    address[][] public wallets;\n', '    mapping(address => uint16) public roles;\n', '\n', '    event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);\n', '    event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);\n', '\n', '    function changeWallet(address _wallet, uint8 _role) external;\n', '    function setManagerPowerful(bool _mode) external;\n', '    function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);\n', '}\n', '\n', 'contract RightAndRoles is IRightAndRoles {\n', '    bool managerPowerful = true;\n', '\n', '    function RightAndRoles(address[] _roles) public {\n', '        uint8 len = uint8(_roles.length);\n', '        require(len > 0&&len <16);\n', '        wallets.length = len;\n', '\n', '        for(uint8 i = 0; i < len; i++){\n', '            wallets[i].push(_roles[i]);\n', '            roles[_roles[i]] += uint16(2)**i;\n', '            emit WalletChanged(_roles[i], address(0),i);\n', '        }\n', '    }\n', '\n', '    function changeClons(address _clon, uint8 _role, bool _mod) external {\n', '        require(wallets[_role][0] == msg.sender&&_clon != msg.sender);\n', '        emit CloneChanged(_clon,_role,_mod);\n', '        uint16 roleMask = uint16(2)**_role;\n', '        if(_mod){\n', '            require(roles[_clon]&roleMask == 0);\n', '            wallets[_role].push(_clon);\n', '        }else{\n', '            address[] storage tmp = wallets[_role];\n', '            uint8 i = 1;\n', '            for(i; i < tmp.length; i++){\n', '                if(tmp[i] == _clon) break;\n', '            }\n', '            require(i > tmp.length);\n', '            tmp[i] = tmp[tmp.length];\n', '            delete tmp[tmp.length];\n', '        }\n', '        roles[_clon] = _mod?roles[_clon]|roleMask:roles[_clon]&~roleMask;\n', '    }\n', '\n', '    // Change the address for the specified role.\n', '    // Available to any wallet owner except the observer.\n', '    // Available to the manager until the round is initialized.\n', '    // The Observer&#39;s wallet or his own manager can change at any time.\n', '    // @ Do I have to use the function      no\n', '    // @ When it is possible to call        depend...\n', '    // @ When it is launched automatically  -\n', '    // @ Who can call the function          staff (all 7+ roles)\n', '    function changeWallet(address _wallet, uint8 _role) external {\n', '        require(wallets[_role][0] == msg.sender || wallets[0][0] == msg.sender || (wallets[1][0] == msg.sender && (managerPowerful || _role == 0)));\n', '        emit WalletChanged(wallets[_role][0],_wallet,_role);\n', '        uint16 roleMask = uint16(2)**_role;\n', '        address[] storage tmp = wallets[_role];\n', '        for(uint8 i = 0; i < tmp.length; i++){\n', '            roles[tmp[i]] = roles[tmp[i]]&~roleMask;\n', '        }\n', '        delete  wallets[_role];\n', '        tmp.push(_wallet);\n', '        roles[_wallet] = roles[_wallet]|roleMask;\n', '    }\n', '\n', '    function setManagerPowerful(bool _mode) external {\n', '        require(wallets[0][0] == msg.sender);\n', '        managerPowerful = _mode;\n', '    }\n', '\n', '    function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool) {\n', '        return roles[_sender]&_roleMask != 0;\n', '    }\n', '\n', '    function getMainWallets() view external returns(address[]){\n', '        address[] memory _wallets = new address[](wallets.length);\n', '        for(uint8 i = 0; i<wallets.length; i++){\n', '            _wallets[i] = wallets[i][0];\n', '        }\n', '        return _wallets;\n', '    }\n', '\n', '    function getCloneWallets(uint8 _role) view external returns(address[]){\n', '        return wallets[_role];\n', '    }\n', '}\n', '\n', 'contract IToken{\n', '    function setUnpausedWallet(address _wallet, bool mode) public;\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function totalSupply() public view returns (uint256);\n', '    function setPause(bool mode) public;\n', '    function setMigrationAgent(address _migrationAgent) public;\n', '    function migrateAll(address[] _holders) public;\n', '    function markTokens(address _beneficiary, uint256 _value) public;\n', '    function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);\n', '    function defrostDate(address _beneficiary) public view returns (uint256 Date);\n', '    function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;\n', '}\n', '\n', 'contract GuidedByRoles {\n', '    IRightAndRoles public rightAndRoles;\n', '    function GuidedByRoles(IRightAndRoles _rightAndRoles) public {\n', '        rightAndRoles = _rightAndRoles;\n', '    }\n', '}\n', '\n', 'contract ERC20Provider is GuidedByRoles {\n', '    function transferTokens(ERC20Basic _token, address _to, uint256 _value) public returns (bool){\n', '        require(rightAndRoles.onlyRoles(msg.sender,2));\n', '        return _token.transfer(_to,_value);\n', '    }\n', '}\n', '\n', 'contract IAllocation {\n', '    function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;\n', '}\n', '\n', 'contract Allocation is GuidedByRoles, IAllocation {\n', '    using SafeMath for uint256;\n', '\n', '    struct Share {\n', '        uint256 proportion;\n', '        uint256 forPart;\n', '    }\n', '\n', '    // How many days to freeze from the moment of finalizing ICO\n', '    uint256 public unlockPart1;\n', '    uint256 public unlockPart2;\n', '    uint256 public totalShare;\n', '\n', '    mapping(address => Share) public shares;\n', '\n', '    ERC20Basic public token;\n', '\n', '    // The contract takes the ERC20 coin address from which this contract will work and from the\n', '    // owner (Team wallet) who owns the funds.\n', '    function Allocation(IRightAndRoles _rightAndRoles,ERC20Basic _token, uint256 _unlockPart1, uint256 _unlockPart2) GuidedByRoles(_rightAndRoles) public{\n', '        unlockPart1 = _unlockPart1;\n', '        unlockPart2 = _unlockPart2;\n', '        token = _token;\n', '    }\n', '\n', '    function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        shares[_beneficiary] = Share(shares[_beneficiary].proportion.add(_proportion),_percenForFirstPart);\n', '        totalShare = totalShare.add(_proportion);\n', '    }\n', '\n', '    //    function unlock() external {\n', '    //        unlockFor(msg.sender);\n', '    //    }\n', '\n', '    // If the time of freezing expired will return the funds to the owner.\n', '    function unlockFor(address _owner) public {\n', '        require(now >= unlockPart1);\n', '        uint256 share = shares[_owner].proportion;\n', '        if (now < unlockPart2) {\n', '            share = share.mul(shares[_owner].forPart)/100;\n', '            shares[_owner].forPart = 0;\n', '        }\n', '        if (share > 0) {\n', '            uint256 unlockedToken = token.balanceOf(this).mul(share).div(totalShare);\n', '            shares[_owner].proportion = shares[_owner].proportion.sub(share);\n', '            totalShare = totalShare.sub(share);\n', '            token.transfer(_owner,unlockedToken);\n', '        }\n', '    }\n', '}\n', '\n', 'contract ICreator{\n', '    IRightAndRoles public rightAndRoles;\n', '    function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);\n', '    function createFinancialStrategy() external returns(IFinancialStrategy);\n', '    function getRightAndRoles() external returns(IRightAndRoles);\n', '}\n', '\n', 'contract Creator is ICreator{\n', '\n', '    function Creator() public{\n', '        address[] memory tmp = new address[](8);\n', '        //Crowdsale.\n', '        tmp[0] = address(this);\n', '        //manager\n', '        tmp[1] = msg.sender;\n', '        //beneficiary\n', '        tmp[2] = 0xD5778CB3844b530eAf9F115aF9F295e378A1b449;\n', '        // Accountant\n', '        // Receives all the tokens for non-ETH investors (when finalizing Round1 & Round2)\n', '        tmp[3] = 0xF637Ba8Fe861AaeF1b9F8B45b9e0B040aF15e018;\n', '        // Observer\n', '        // Has only the right to call paymentsInOtherCurrency (please read the document)\n', '        tmp[4] = 0x8a91aC199440Da0B45B2E278f3fE616b1bCcC494;\n', '        // Bounty - 8% tokens\n', '        tmp[5] = 0x148595DB00a4AA94a1b05f8Cd1aA6D9B4FdfFC21;\n', '        // Company - 0% tokens - skip\n', '        tmp[6] = 0x148595DB00a4AA94a1b05f8Cd1aA6D9B4FdfFC21;\n', '        // Team - 12% tokens, freeze 1 year\n', '        tmp[7] = 0x1d3a6Fc3f6Ce8d6E6469C2bD4354759d50175220;\n', '        rightAndRoles = new RightAndRoles(tmp);\n', '    }\n', '\n', '    function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation) {\n', '        Allocation allocation = new Allocation(rightAndRoles,ERC20Basic(_token),_unlockPart1,_unlockPart2);\n', '        return allocation;\n', '    }\n', '\n', '    function createFinancialStrategy() external returns(IFinancialStrategy) {\n', '        return new FinancialStrategy(rightAndRoles);\n', '    }\n', '\n', '    function getRightAndRoles() external returns(IRightAndRoles){\n', '        rightAndRoles.changeWallet(msg.sender,0);\n', '        return rightAndRoles;\n', '    }\n', '}\n', '\n', 'contract FinancialStrategy is IFinancialStrategy, GuidedByRoles,ERC20Provider{\n', '    using SafeMath for uint256;\n', '\n', '    uint8 public step;\n', '\n', '    mapping (uint8 => mapping (address => uint256)) public deposited;\n', '\n', '                             // Partner 0   Partner 1    Partner 2\n', '    uint256[0] public percent;\n', '    uint256[0] public cap; // QUINTILLIONS\n', '    uint256[0] public debt;\n', '    uint256[0] public total;                                 // QUINTILLIONS\n', '    uint256[0] public took;\n', '    uint256[0] public ready;\n', '\n', '    address[0] public wallets;\n', '\n', '    uint256 public benTook=0;\n', '    uint256 public benReady=0;\n', '    uint256 public newCash=0;\n', '    uint256 public cashHistory=0;\n', '\n', '    address public benWallet=0;\n', '\n', '    modifier canGetCash(){\n', '        require(state == State.Closed);\n', '        _;\n', '    }\n', '\n', '    function FinancialStrategy(IRightAndRoles _rightAndRoles) GuidedByRoles(_rightAndRoles) public {\n', '        emit Started();\n', '    }\n', '\n', '    function balance() external view returns(uint256){\n', '        return address(this).balance;\n', '    }\n', '\n', '    \n', '    function deposit(address _investor) external payable {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        require(state == State.Active);\n', '        deposited[step][_investor] = deposited[step][_investor].add(msg.value);\n', '        newCash = newCash.add(msg.value);\n', '        cashHistory += msg.value;\n', '        emit Deposited(_investor,msg.value);\n', '    }\n', '\n', '\n', '    // 0 - destruct\n', '    // 1 - close\n', '    // 2 - restart\n', '    // 3 - refund\n', '    // 4 - calc\n', '    // 5 - update Exchange                                                                      \n', '    function setup(uint8 _state, bytes32[] _params) external {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '\n', '        if (_state == 0)  {\n', '            require(_params.length == 1);\n', '            // call from Crowdsale.distructVault(true) for exit\n', '            // arg1 - nothing\n', '            // arg2 - nothing\n', '            selfdestruct(address(_params[0]));\n', '\n', '        }\n', '        else if (_state == 1 ) {\n', '            require(_params.length == 0);\n', '            // Call from Crowdsale.finalization()\n', '            //   [1] - successfull round (goalReach)\n', '            //   [3] - failed round (not enough money)\n', '            // arg1 = weiTotalRaised();\n', '            // arg2 = nothing;\n', '        \n', '            require(state == State.Active);\n', '            //internalCalc(_arg1);\n', '            state = State.Closed;\n', '            emit Closed();\n', '        \n', '        }\n', '        else if (_state == 2) {\n', '            require(_params.length == 0);\n', '            // Call from Crowdsale.initialization()\n', '            // arg1 = weiTotalRaised();\n', '            // arg2 = nothing;\n', '            require(state == State.Closed);\n', '            require(address(this).balance == 0);\n', '            state = State.Active;\n', '            step++;\n', '            emit Started();\n', '        \n', '        }\n', '        else if (_state == 3 ) {\n', '            require(_params.length == 0);\n', '            require(state == State.Active);\n', '            state = State.Refunding;\n', '            emit RefundsEnabled();\n', '        }\n', '        else if (_state == 4) {\n', '            require(_params.length == 2);\n', '            //onlyPartnersOrAdmin(address(_params[1]));\n', '            internalCalc(uint256(_params[0]));\n', '        }\n', '        else if (_state == 5) {\n', '            // arg1 = old ETH/USD (exchange)\n', '            // arg2 = new ETH/USD (_ETHUSD)\n', '            require(_params.length == 2);\n', '            for (uint8 user=0; user<cap.length; user++) cap[user]=cap[user].mul(uint256(_params[0])).div(uint256(_params[1]));\n', '        }\n', '\n', '    }\n', '\n', '    function freeCash() view public returns(uint256){\n', '        return newCash+benReady;\n', '    }\n', '\n', '    function internalCalc(uint256 _allValue) internal {\n', '\n', '        uint256 free=newCash+benReady;\n', '        uint256 common=0;\n', '        uint256 prcSum=0;\n', '        uint256 plan=0;\n', '        uint8[] memory indexes = new uint8[](percent.length);\n', '        uint8 count = 0;\n', '\n', '        if (free==0) return;\n', '\n', '        uint8 i;\n', '\n', '        for (i =0; i <percent.length; i++) {\n', '            plan=_allValue*percent[i]/100;\n', '\n', '            if(cap[i] != 0 && plan > cap[i]) plan = cap[i];\n', '\n', '            if (total[i] >= plan) {\n', '                debt[i]=0;\n', '                continue;\n', '            }\n', '\n', '            plan -= total[i];\n', '            debt[i] = plan;\n', '            common += plan;\n', '            indexes[count++] = i;\n', '            prcSum += percent[i];\n', '        }\n', '        if(common > free){\n', '            benReady = 0;\n', '            uint8 j = 0;\n', '            while (j < count){\n', '                i = indexes[j++];\n', '                plan = free*percent[i]/prcSum;\n', '                if(plan + total[i] <= cap[i] || cap[i] ==0){\n', '                    debt[i] = plan;\n', '                    continue;\n', '                }\n', '                debt[i] = cap[i] - total[i]; //&#39;total&#39; is always less than &#39;cap&#39;\n', '                free -= debt[i];\n', '                prcSum -= percent[i];\n', '                indexes[j-1] = indexes[--count];\n', '                j = 0;\n', '            }\n', '        }\n', '        common = 0;\n', '        for(i = 0; i < debt.length; i++){\n', '            total[i] += debt[i];\n', '            ready[i] += debt[i];\n', '            common += ready[i];\n', '        }\n', '        benReady = address(this).balance - common;\n', '        newCash = 0;\n', '    }\n', '\n', '    function refund(address _investor) external {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[step][_investor];\n', '        require(depositedValue > 0);\n', '        deposited[step][_investor] = 0;\n', '        _investor.transfer(depositedValue);\n', '        emit Refunded(_investor, depositedValue);\n', '    }\n', '\n', '    // Call from Crowdsale:\n', '    function getBeneficiaryCash() external canGetCash {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        address _beneficiary = rightAndRoles.wallets(2,0);\n', '        uint256 move=benReady;\n', '        benWallet=_beneficiary;\n', '        if (move == 0) return;\n', '\n', '        emit Receive(_beneficiary, move);\n', '        benReady = 0;\n', '        benTook += move;\n', '        \n', '        _beneficiary.transfer(move);\n', '    \n', '    }\n', '\n', '\n', '    // Call from Crowdsale:\n', '    function getPartnerCash(uint8 _user, address _msgsender) external canGetCash {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        require(_user<wallets.length);\n', '\n', '        onlyPartnersOrAdmin(_msgsender);\n', '\n', '        uint256 move=ready[_user];\n', '        if (move==0) return;\n', '\n', '        emit Receive(wallets[_user], move);\n', '        ready[_user]=0;\n', '        took[_user]+=move;\n', '\n', '        wallets[_user].transfer(move);\n', '    \n', '    }\n', '\n', '    function onlyPartnersOrAdmin(address _sender) internal view {\n', '        if (!rightAndRoles.onlyRoles(_sender,65535)) {\n', '            for (uint8 i=0; i<wallets.length; i++) {\n', '                if (wallets[i]==_sender) break;\n', '            }\n', '            if (i>=wallets.length) {\n', '                revert();\n', '            }\n', '        }\n', '    }\n', '}']