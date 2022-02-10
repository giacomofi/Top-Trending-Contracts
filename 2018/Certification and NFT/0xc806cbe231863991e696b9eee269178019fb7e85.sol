['pragma solidity 0.4.24;\n', 'library SafeMath {\n', '    /* Internals */\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a + b;\n', '        assert( c >= a );\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a - b;\n', '        assert( c <= a );\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a * b;\n', '        assert( c == 0 || c / a == b );\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        return a / b;\n', '    }\n', '    function pow(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a ** b;\n', '        assert( c % a == 0 );\n', '        return a ** b;\n', '    }\n', '}\n', 'contract Token {\n', '    /* Externals */\n', '    function transfer(address _to, uint256 _amount) external returns (bool _success) {}\n', '    function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {}\n', '    /* Constants */\n', '    function balanceOf(address _owner) public view returns (uint256 _balance) {}\n', '}\n', 'contract MultiOwnerWallet {\n', '    /* Declarations */\n', '    using SafeMath for uint256;\n', '    /* Structures */\n', '    struct action_s {\n', '        address origin;\n', '        uint256 voteCounter;\n', '        uint256 uid;\n', '        mapping(address => uint256) voters;\n', '    }\n', '    /* Variables */\n', '    mapping(address => bool) public owners;\n', '    mapping(bytes32 => action_s) public actions;\n', '    uint256 public actionVotedRate;\n', '    uint256 public ownerCounter;\n', '    uint256 public voteUID;\n', '    Token public token;\n', '    /* Constructor */\n', '    constructor(address _tokenAddress, uint256 _actionVotedRate, address[] _owners) public {\n', '        uint256 i;\n', '        token = Token(_tokenAddress);\n', '        require( _actionVotedRate <= 100 );\n', '        actionVotedRate = _actionVotedRate;\n', '        for ( i=0 ; i<_owners.length ; i++ ) {\n', '            owners[_owners[i]] = true;\n', '        }\n', '        ownerCounter = _owners.length;\n', '    }\n', '    /* Fallback */\n', '    function () public {\n', '        revert();\n', '    }\n', '    /* Externals */\n', '    function transfer(address _to, uint256 _amount) external returns (bool _success) {\n', '        bytes32 _hash;\n', '        bool    _subResult;\n', '        _hash = keccak256(address(token), &#39;transfer&#39;, _to, _amount);\n', '        if ( actions[_hash].origin == 0x00 ) {\n', '            emit newTransferAction(_hash, _to, _amount, msg.sender);\n', '        }\n', '        if ( doVote(_hash) ) {\n', '            _subResult = token.transfer(_to, _amount);\n', '            require( _subResult );\n', '        }\n', '        return true;\n', '    }\n', '    function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {\n', '        bytes32 _hash;\n', '        bool    _subResult;\n', '        _hash = keccak256(address(token), &#39;bulkTransfer&#39;, _to, _amount);\n', '        if ( actions[_hash].origin == 0x00 ) {\n', '            emit newBulkTransferAction(_hash, _to, _amount, msg.sender);\n', '        }\n', '        if ( doVote(_hash) ) {\n', '            _subResult = token.bulkTransfer(_to, _amount);\n', '            require( _subResult );\n', '        }\n', '        return true;\n', '    }\n', '    function changeTokenAddress(address _tokenAddress) external returns (bool _success) {\n', '        bytes32 _hash;\n', '        _hash = keccak256(address(token), &#39;changeTokenAddress&#39;, _tokenAddress);\n', '        if ( actions[_hash].origin == 0x00 ) {\n', '            emit newChangeTokenAddressAction(_hash, _tokenAddress, msg.sender);\n', '        }\n', '        if ( doVote(_hash) ) {\n', '            token = Token(_tokenAddress);\n', '        }\n', '        return true;\n', '    }\n', '    function addNewOwner(address _owner) external returns (bool _success) {\n', '        bytes32 _hash;\n', '        require( ! owners[_owner] );\n', '        _hash = keccak256(address(token), &#39;addNewOwner&#39;, _owner);\n', '        if ( actions[_hash].origin == 0x00 ) {\n', '            emit newAddNewOwnerAction(_hash, _owner, msg.sender);\n', '        }\n', '        if ( doVote(_hash) ) {\n', '            ownerCounter = ownerCounter.add(1);\n', '            owners[_owner] = true;\n', '        }\n', '        return true;\n', '    }\n', '    function delOwner(address _owner) external returns (bool _success) {\n', '        bytes32 _hash;\n', '        require( owners[_owner] );\n', '        _hash = keccak256(address(token), &#39;delOwner&#39;, _owner);\n', '        if ( actions[_hash].origin == 0x00 ) {\n', '            emit newDelOwnerAction(_hash, _owner, msg.sender);\n', '        }\n', '        if ( doVote(_hash) ) {\n', '            ownerCounter = ownerCounter.sub(1);\n', '            owners[_owner] = false;\n', '        }\n', '        return true;\n', '    }\n', '    /* Constants */\n', '    function selfBalance() public view returns (uint256 _balance) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint256 _balance) {\n', '        return token.balanceOf(_owner);\n', '    }\n', '    function hasVoted(bytes32 _hash, address _owner) public view returns (bool _voted) {\n', '        return actions[_hash].origin != 0x00 && actions[_hash].voters[_owner] == actions[_hash].uid;\n', '    }\n', '    /* Internals */\n', '    function doVote(bytes32 _hash) internal returns (bool _voted) {\n', '        require( owners[msg.sender] );\n', '        if ( actions[_hash].origin == 0x00 ) {\n', '            voteUID = voteUID.add(1);\n', '            actions[_hash].origin = msg.sender;\n', '            actions[_hash].voteCounter = 1;\n', '            actions[_hash].uid = voteUID;\n', '        } else if ( ( actions[_hash].voters[msg.sender] != actions[_hash].uid ) && actions[_hash].origin != msg.sender ) {\n', '            actions[_hash].voters[msg.sender] = actions[_hash].uid;\n', '            actions[_hash].voteCounter = actions[_hash].voteCounter.add(1);\n', '            emit vote(_hash, msg.sender);\n', '        }\n', '        if ( actions[_hash].voteCounter.mul(100).div(ownerCounter) >= actionVotedRate ) {\n', '            _voted = true;\n', '            emit votedAction(_hash);\n', '            delete actions[_hash];\n', '        }\n', '    }\n', '    /* Events */\n', '    event newTransferAction(bytes32 _hash, address _to, uint256 _amount, address _origin);\n', '    event newBulkTransferAction(bytes32 _hash, address[] _to, uint256[] _amount, address _origin);\n', '    event newChangeTokenAddressAction(bytes32 _hash, address _tokenAddress, address _origin);\n', '    event newAddNewOwnerAction(bytes32 _hash, address _owner, address _origin);\n', '    event newDelOwnerAction(bytes32 _hash, address _owner, address _origin);\n', '    event vote(bytes32 _hash, address _voter);\n', '    event votedAction(bytes32 _hash);\n', '}']