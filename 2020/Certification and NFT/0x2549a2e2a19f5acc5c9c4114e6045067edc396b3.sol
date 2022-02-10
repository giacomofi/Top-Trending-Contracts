['/* \n', 'Built by Cubebit Labs for Adcube\n', '\n', 'Version 2 - Reduced gas usage by frontend intervention\n', '\n', '*/\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'contract Adcube {\n', '    \n', '    address public owner;\n', '    uint256 public level = 1;\n', '    uint256 public position = 1;\n', '    uint256 public levelThreshold = 1;\n', '    uint256 public price = 50000000000000000;\n', '    uint256 public spill = 3880000000000000;\n', '    uint256 public referral = 3880000000000000;\n', '    uint256 public totalUsers = 0;\n', '    uint256 public totalAccounts = 0;\n', '    \n', '    constructor(){\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    struct User{\n', '        bool active;\n', '        bool uplinePaid;\n', '        uint256 level;\n', '        uint256 position;\n', '        uint256 accounts;\n', '        uint256 paid;\n', '        address referrer;\n', '        address[] uplines;\n', '        address[] downlines;\n', '    }\n', '    \n', '    struct Level{\n', '        address[] positions;\n', '    }\n', '    \n', '    mapping(address => User) users;\n', '    \n', '    mapping(uint256 => Level) levels;\n', '    \n', '    function adminRegister(address _user, address _referrer, uint256 _accounts) public onlyOwner returns(uint256,uint256){\n', '        require(_accounts < 4 && _accounts > 0);\n', '        User storage u = users[_user];\n', '        Level storage l = levels[level];\n', '        l.positions.push(_user);\n', '        u.active = true;\n', '        u.position = position;\n', '        u.level = level;\n', '        u.accounts = _accounts;\n', '        u.referrer = _referrer;\n', '        if(l.positions.length == levelThreshold){\n', '            position = position + 1;\n', '            levelThreshold = levelThreshold * 3;\n', '            level = level + 1;\n', '        }\n', '        else{\n', '            position = position + 1;\n', '        }\n', '       totalAccounts = totalAccounts + _accounts;\n', '       totalUsers = totalUsers + 1;\n', '       return(u.level,u.position);\n', '    }\n', '    \n', '    function register(address _user,address _referrer, uint256 _accounts) external payable returns(uint256, uint256){\n', '        require(_accounts < 4 && _accounts > 0);\n', '        require(msg.value == price * _accounts);\n', '        User storage r = users[_referrer];\n', '        require(r.active == true);\n', '        User storage u = users[_user];\n', '        Level storage l = levels[level];\n', '        l.positions.push(_user);\n', '        u.active = true;\n', '        u.position = position;\n', '        u.level = level;\n', '        u.accounts = _accounts;\n', '        u.referrer = _referrer;\n', '        if(l.positions.length == levelThreshold){\n', '            position = position + 1;\n', '            levelThreshold = levelThreshold * 3;\n', '            level = level + 1;\n', '        }\n', '        else{\n', '            position = position + 1;\n', '        }\n', '       totalAccounts = totalAccounts + _accounts;\n', '       totalUsers = totalUsers + 1;\n', '       return(u.level,u.position);\n', '    }\n', '\n', '    function sendSpill(address _user,address[] memory uplines) public onlyOwner{\n', '        User storage a = users[_user];\n', '        require(a.uplinePaid == false);\n', '        require(a.active == true);\n', '        a.uplines = uplines;\n', '        a.uplinePaid = true;\n', '        payable(a.referrer).transfer(referral);\n', '        if(uplines.length < 9) {\n', '            for(uint256 i=0;i < uplines.length; i++){\n', '            User storage u = users[uplines[i]];\n', '            u.paid = u.paid + 1;\n', '            u.downlines.push(_user);\n', '            if(u.accounts == 1 && u.paid == 39){\n', '                u.active = false;\n', '            }\n', '            else if(u.accounts == 2 && u.paid == 1092){\n', '                u.active = false;\n', '            }\n', '            else{\n', '                if(u.paid == 29523){\n', '                    u.active = false;\n', '                }\n', '            }\n', '            payable(uplines[i]).transfer(spill);\n', '         }\n', '        }\n', '        else{\n', '          for(uint256 i=0; i < 9; i++){\n', '              User storage u = users[uplines[i]];\n', '              u.paid = u.paid + 1;\n', '              u.downlines.push(_user);\n', '              if(u.accounts == 1 && u.paid == 39){\n', '                u.active = false;\n', '              }\n', '              else if(u.accounts == 2 && u.paid == 1092){\n', '                u.active = false;\n', '              }\n', '              else{\n', '                if(u.paid == 29523){\n', '                    u.active = false;\n', '              }\n', '            }\n', '            payable(uplines[i]).transfer(spill);\n', '          }\n', '        }\n', '    }\n', '    \n', '    function purchase(uint256 _accounts) external payable{\n', '        require(_accounts > 0 && _accounts < 3);\n', '        User storage u = users[msg.sender];\n', '        require(u.accounts + _accounts <= 3);\n', '        require(msg.value == _accounts * price);\n', '        u.accounts = u.accounts + _accounts;\n', '    }\n', '    \n', '    function deactivate(address _user) public onlyOwner{\n', '        User storage u = users[_user];\n', '        u.active = false;\n', '    }\n', '    \n', '    function activate(address _user) public onlyOwner{\n', '        User storage u = users[_user];\n', '        u.active = true;\n', '    }\n', '    \n', '    function markPaid(address _user) public onlyOwner{\n', '        User storage u = users[_user];\n', '        u.uplinePaid = true;\n', '    }\n', '    \n', '    function updateOwnership(address _newOwner) public onlyOwner{\n', '        owner = _newOwner;\n', '    }\n', '    \n', '    function updateFiatPrice(uint256 _price, uint256 _referralBonus, uint256 _spillover) public onlyOwner{\n', '         price = _price;\n', '         spill = _spillover;\n', '         referral = _referralBonus;\n', '    }\n', '    \n', '    function fetchUsers(address _user) public view returns(bool _uplinePaid, uint256 _account,uint256 _paid, address[] memory _uplines, address[] memory _downlines, uint256 _level, uint256 _position, address _referrer){\n', '        User storage u = users[_user];\n', '        return(u.uplinePaid,u.accounts,u.paid,u.uplines,u.downlines,u.level,u.position,u.referrer);\n', '    }\n', '    \n', '    function fetchLevels(uint256 _level) public view returns(address[] memory){\n', '        Level storage l = levels[_level];\n', '        return(l.positions);\n', '    }\n', '    \n', '    function validate(address _user) public view returns(bool,bool){\n', '        User storage u = users[_user];\n', '        return(u.active,u.uplinePaid);\n', '    }\n', '    \n', '    function balanceOf() external view returns(uint256){\n', '        return address(this).balance;\n', '    }\n', '    \n', '    function drain() public onlyOwner{\n', '        payable(owner).transfer(address(this).balance);\n', '    }\n', '}']