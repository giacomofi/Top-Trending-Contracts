['pragma solidity ^0.4.23;\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function withdraw() public onlyOwner{\n', '      owner.transfer(address(this).balance);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract SimpleERC721{\n', '    function ownerOf(uint256 _tokenId) external view returns (address owner);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) external;\n', '    function transfer(address _to, uint256 _tokenId) external;\n', '}\n', '\n', 'contract Solitaire is Ownable {\n', '    event NewAsset(uint256 index,address nft, uint256 token, address owner, string url,string memo);\n', '\n', '    struct Asset{\n', '        address nft;\n', '        uint256 tokenId;\n', '        address owner;\n', '        string url;\n', '        string memo;\n', '    }\n', '    uint256 public fee = 5 finney;\n', '    Asset[] queue;\n', '\n', '    function init(address _nft,uint256 _id,address _owner,string _url,string _memo) public onlyOwner{\n', '        require(queue.length<=1);\n', '        Asset memory a = Asset({\n', '            nft: _nft,\n', '            tokenId: _id,\n', '            owner: _owner,\n', '            url: _url,\n', '            memo: _memo\n', '        });\n', '        if (queue.length==0){\n', '            queue.push(a);\n', '        }else{\n', '            queue[0] = a;\n', '        }\n', '        emit NewAsset(0,_nft,_id,_owner,_url,_memo);\n', '    }\n', '    \n', '    function refund(address _nft,uint256 _id,address _owner) public onlyOwner{\n', '        require(_owner != address(0));\n', '        SimpleERC721 se = SimpleERC721(_nft);\n', '        require(se.ownerOf(_id) == address(this));\n', '        se.transfer(_owner,_id);\n', '    }\n', '    \n', '    function setfee(uint256 _fee) public onlyOwner{\n', '        require(_fee>=0);\n', '        fee = _fee;\n', '    }\n', '    \n', '    function totalAssets() public view returns(uint256){\n', '        return queue.length;\n', '    }\n', '    \n', '    function getAsset(uint256 _index) public view returns(address _nft,uint256 _id,address _owner,string _url,string _memo){\n', '        require(_index<queue.length);\n', '        Asset memory _a = queue[_index];\n', '        _nft = _a.nft;\n', '        _id = _a.tokenId;\n', '        _owner = _a.owner;\n', '        _url = _a.url;\n', '        _memo = _a.memo;\n', '    }\n', '    \n', '    function addLayer(address _nft,uint256 _id,string _url,string _memo) public payable{\n', '        require(msg.value >=fee);\n', '        require(_nft != address(0));\n', '        SimpleERC721 se = SimpleERC721(_nft);\n', '        require(se.ownerOf(_id) == msg.sender);\n', '        se.transferFrom(msg.sender,address(this),_id);\n', '        // double check\n', '        require(se.ownerOf(_id) == address(this));\n', '        Asset memory last = queue[queue.length -1];\n', '        SimpleERC721 lastse = SimpleERC721(last.nft);\n', '        lastse.transfer(msg.sender,last.tokenId);\n', '        Asset memory newasset = Asset({\n', '            nft: _nft,\n', '            tokenId: _id,\n', '            owner: msg.sender,\n', '            url: _url,\n', '            memo: _memo\n', '        });\n', '        uint256 index = queue.push(newasset) - 1;\n', '        emit NewAsset(index,_nft,  _id,  msg.sender,_url,_memo);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.23;\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function withdraw() public onlyOwner{\n', '      owner.transfer(address(this).balance);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract SimpleERC721{\n', '    function ownerOf(uint256 _tokenId) external view returns (address owner);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) external;\n', '    function transfer(address _to, uint256 _tokenId) external;\n', '}\n', '\n', 'contract Solitaire is Ownable {\n', '    event NewAsset(uint256 index,address nft, uint256 token, address owner, string url,string memo);\n', '\n', '    struct Asset{\n', '        address nft;\n', '        uint256 tokenId;\n', '        address owner;\n', '        string url;\n', '        string memo;\n', '    }\n', '    uint256 public fee = 5 finney;\n', '    Asset[] queue;\n', '\n', '    function init(address _nft,uint256 _id,address _owner,string _url,string _memo) public onlyOwner{\n', '        require(queue.length<=1);\n', '        Asset memory a = Asset({\n', '            nft: _nft,\n', '            tokenId: _id,\n', '            owner: _owner,\n', '            url: _url,\n', '            memo: _memo\n', '        });\n', '        if (queue.length==0){\n', '            queue.push(a);\n', '        }else{\n', '            queue[0] = a;\n', '        }\n', '        emit NewAsset(0,_nft,_id,_owner,_url,_memo);\n', '    }\n', '    \n', '    function refund(address _nft,uint256 _id,address _owner) public onlyOwner{\n', '        require(_owner != address(0));\n', '        SimpleERC721 se = SimpleERC721(_nft);\n', '        require(se.ownerOf(_id) == address(this));\n', '        se.transfer(_owner,_id);\n', '    }\n', '    \n', '    function setfee(uint256 _fee) public onlyOwner{\n', '        require(_fee>=0);\n', '        fee = _fee;\n', '    }\n', '    \n', '    function totalAssets() public view returns(uint256){\n', '        return queue.length;\n', '    }\n', '    \n', '    function getAsset(uint256 _index) public view returns(address _nft,uint256 _id,address _owner,string _url,string _memo){\n', '        require(_index<queue.length);\n', '        Asset memory _a = queue[_index];\n', '        _nft = _a.nft;\n', '        _id = _a.tokenId;\n', '        _owner = _a.owner;\n', '        _url = _a.url;\n', '        _memo = _a.memo;\n', '    }\n', '    \n', '    function addLayer(address _nft,uint256 _id,string _url,string _memo) public payable{\n', '        require(msg.value >=fee);\n', '        require(_nft != address(0));\n', '        SimpleERC721 se = SimpleERC721(_nft);\n', '        require(se.ownerOf(_id) == msg.sender);\n', '        se.transferFrom(msg.sender,address(this),_id);\n', '        // double check\n', '        require(se.ownerOf(_id) == address(this));\n', '        Asset memory last = queue[queue.length -1];\n', '        SimpleERC721 lastse = SimpleERC721(last.nft);\n', '        lastse.transfer(msg.sender,last.tokenId);\n', '        Asset memory newasset = Asset({\n', '            nft: _nft,\n', '            tokenId: _id,\n', '            owner: msg.sender,\n', '            url: _url,\n', '            memo: _memo\n', '        });\n', '        uint256 index = queue.push(newasset) - 1;\n', '        emit NewAsset(index,_nft,  _id,  msg.sender,_url,_memo);\n', '    }\n', '\n', '}']
