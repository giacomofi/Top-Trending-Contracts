['pragma solidity ^0.5.8;\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract IERC721 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20BasicInterface {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    uint8 public decimals;\n', '}\n', '\n', 'contract Bussiness is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '    address public ceoAddress = address(0x2076A228E6eB670fd1C604DE574d555476520DB7);\n', '    IERC721 public erc721Address = IERC721(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B);\n', '    ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);\n', '    uint256 public ETHFee = 0; // 25 = 2,5 %\n', '    uint256 public Percen = 1000;\n', '    uint256 public HBWALLETExchange = 21;\n', '    // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2\n', '    uint256 public limitETHFee = 0;\n', '    uint256 public limitHBWALLETFee = 0;\n', '    uint256 public hightLightFee = 30000000000000000;\n', '    constructor() public {}\n', '    struct Price {\n', '        address payable tokenOwner;\n', '        uint256 price;\n', '        uint256 fee;\n', '        uint256 hbfee;\n', '        bool isHightlight;\n', '    }\n', '\n', '    uint256[] public arrayTokenIdSale;\n', '    mapping(uint256 => Price) public prices;\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the ceo address.\n', '     */\n', '    modifier onlyCeoAddress() {\n', '        require(msg.sender == ceoAddress);\n', '        _;\n', '    }\n', '    modifier isOwnerOf(uint256 _tokenId) {\n', '        require(erc721Address.ownerOf(_tokenId) == msg.sender);\n', '        _;\n', '    }\n', '    // Move the last element to the deleted spot.\n', '    // Delete the last element, then correct the length.\n', '    function _burnArrayTokenIdSale(uint8 index)  internal {\n', '        if (index >= arrayTokenIdSale.length) return;\n', '\n', '        for (uint i = index; i<arrayTokenIdSale.length-1; i++){\n', '            arrayTokenIdSale[i] = arrayTokenIdSale[i+1];\n', '        }\n', '        delete arrayTokenIdSale[arrayTokenIdSale.length-1];\n', '        arrayTokenIdSale.length--;\n', '    }\n', '\n', '    function _burnArrayTokenIdSaleByArr(uint8[] memory arr) internal {\n', '        for(uint8 i; i<arr.length; i++){\n', '            _burnArrayTokenIdSale(i);\n', '        }\n', '\n', '    }\n', '    function ownerOf(uint256 _tokenId) public view returns (address){\n', '        return erc721Address.ownerOf(_tokenId);\n', '    }\n', '\n', '    function balanceOf() public view returns (uint256){\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getApproved(uint256 _tokenId) public view returns (address){\n', '        return erc721Address.getApproved(_tokenId);\n', '    }\n', '\n', '    function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, bool _isHightLight) internal {\n', '        prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);\n', '        arrayTokenIdSale.push(_tokenId);\n', '    }\n', '\n', '    function calPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {\n', '        uint256 ethfee;\n', '        uint256 _hightLightFee = 0;\n', '        uint256 ethNeed;\n', '        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {\n', '            _hightLightFee = hightLightFee;\n', '        }\n', '        if (prices[_tokenId].price < _ethPrice) {\n', '            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);\n', '            if(prices[_tokenId].price == 0) {\n', '                if (ethfee >= limitETHFee) {\n', '                    ethNeed = ethfee.add(_hightLightFee);\n', '                } else {\n', '                    ethNeed = limitETHFee.add(_hightLightFee);\n', '                }\n', '            }\n', '\n', '        }\n', '        return (ethNeed, _hightLightFee);\n', '    }\n', '    function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_tokenId) {\n', '        require(prices[_tokenId].price != _ethPrice);\n', '        uint256 ethfee;\n', '        uint256 _hightLightFee = 0;\n', '        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {\n', '            _hightLightFee = hightLightFee;\n', '        }\n', '        if (prices[_tokenId].price < _ethPrice) {\n', '            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);\n', '            if(prices[_tokenId].price == 0) {\n', '                if (ethfee >= limitETHFee) {\n', '                    require(msg.value == ethfee.add(_hightLightFee));\n', '                } else {\n', '                    require(msg.value == limitETHFee.add(_hightLightFee));\n', '                    ethfee = limitETHFee;\n', '                }\n', '            }\n', '            ethfee = ethfee.add(prices[_tokenId].fee);\n', '        } else ethfee = _ethPrice.mul(ETHFee).div(Percen);\n', '\n', '        setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight == 1);\n', '    }\n', '    function calPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){\n', '        uint fee;\n', '        uint256 ethfee;\n', '        uint _hightLightFee = 0;\n', '        uint hbNeed;\n', '        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {\n', '            // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);\n', '            _hightLightFee = hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);\n', '        }\n', '        if (prices[_tokenId].price < _ethPrice) {\n', '            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);\n', '            fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);\n', '            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)\n', '            if(prices[_tokenId].price == 0) {\n', '                if (fee >= limitHBWALLETFee) {\n', '                    hbNeed = fee.add(_hightLightFee);\n', '                } else {\n', '                    hbNeed = limitHBWALLETFee.add(_hightLightFee);\n', '                }\n', '            }\n', '        }\n', '        return hbNeed;\n', '    }\n', '    function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_tokenId) {\n', '        require(prices[_tokenId].price != _ethPrice);\n', '        uint fee;\n', '        uint256 ethfee;\n', '        uint _hightLightFee = 0;\n', '        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {\n', '            _hightLightFee = hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);\n', '        }\n', '        if (prices[_tokenId].price < _ethPrice) {\n', '            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);\n', '            fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);\n', '            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)\n', '            if(prices[_tokenId].price == 0) {\n', '                if (fee >= limitHBWALLETFee) {\n', '                    require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));\n', '                } else {\n', '                    require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee.add(_hightLightFee)));\n', '                    fee = limitHBWALLETFee;\n', '                }\n', '            }\n', '            fee = fee.add(prices[_tokenId].hbfee);\n', '        } else {\n', '            ethfee = _ethPrice.mul(ETHFee).div(Percen);\n', '            fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);\n', '        }\n', '\n', '        setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight == 1);\n', '    }\n', '\n', '    function removePrice(uint256 _tokenId) public isOwnerOf(_tokenId) returns (uint256){\n', '        if (prices[_tokenId].fee > 0) msg.sender.transfer(prices[_tokenId].fee);\n', '        else if (prices[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[_tokenId].hbfee);\n', '        resetPrice(_tokenId);\n', '        return prices[_tokenId].price;\n', '    }\n', '\n', '    function setFee(uint256 _ethFee, uint _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint, uint256){\n', '        require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);\n', '        ETHFee = _ethFee;\n', '        HBWALLETExchange = _HBWALLETExchange;\n', '        hightLightFee = _hightLightFee;\n', '        return (ETHFee, HBWALLETExchange, hightLightFee);\n', '    }\n', '\n', '    function setLimitFee(uint256 _ethlimitFee, uint _hbWalletlimitFee) public onlyOwner returns (uint256, uint){\n', '        require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);\n', '        limitETHFee = _ethlimitFee;\n', '        limitHBWALLETFee = _hbWalletlimitFee;\n', '        return (limitETHFee, limitHBWALLETFee);\n', '    }\n', '\n', '    function _withdraw(uint256 amount, uint256 _amountHB) internal {\n', '        require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);\n', '        if(amount > 0) {\n', '            msg.sender.transfer(amount);\n', '        }\n', '        if(_amountHB > 0) {\n', '            hbwalletToken.transfer(msg.sender, _amountHB);\n', '        }\n', '    }\n', '    function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {\n', '        _withdraw(amount, _amountHB);\n', '    }\n', '    function cancelBussiness() public onlyCeoAddress {\n', '        uint256[] memory arr = arrayTokenIdSale;\n', '        uint length = arrayTokenIdSale.length;\n', '        for (uint i = 0; i < length; i++) {\n', '            if (prices[arr[i]].tokenOwner == erc721Address.ownerOf(arr[i])) {\n', '                if (prices[arr[i]].fee > 0) {\n', '                    uint256 eth = prices[arr[i]].fee;\n', '                    if(prices[arr[i]].isHightlight) eth = eth.add(hightLightFee);\n', '                    if(address(this).balance >= eth) {\n', '                        prices[arr[i]].tokenOwner.transfer(eth);\n', '                    }\n', '                }\n', '                else if (prices[arr[i]].hbfee > 0) {\n', '                    uint hb = prices[arr[i]].hbfee;\n', '                    if(prices[arr[i]].isHightlight) hb = hb.add(hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));\n', '                    if(hbwalletToken.balanceOf(address(this)) >= hb) {\n', '                        hbwalletToken.transfer(prices[arr[i]].tokenOwner, hb);\n', '                    }\n', '                }\n', '                resetPrice(arr[i]);\n', '            }\n', '        }\n', '        _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));\n', '    }\n', '\n', '    function revenue() public view returns (uint256, uint){\n', '        uint256 ethfee = 0;\n', '        uint256 hbfee = 0;\n', '        for (uint i = 0; i < arrayTokenIdSale.length; i++) {\n', '            if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {\n', '                if (prices[arrayTokenIdSale[i]].fee > 0) {\n', '                    ethfee = ethfee.add(prices[arrayTokenIdSale[i]].fee);\n', '                }\n', '                else if (prices[arrayTokenIdSale[i]].hbfee > 0) {\n', '                    hbfee = hbfee.add(prices[arrayTokenIdSale[i]].hbfee);\n', '                }\n', '            }\n', '        }\n', '        uint256 eth = address(this).balance.sub(ethfee);\n', '        uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);\n', '        return (eth, hb);\n', '    }\n', '\n', '    function changeCeo(address _address) public onlyCeoAddress {\n', '        require(_address != address(0));\n', '        ceoAddress = _address;\n', '\n', '    }\n', '\n', '    function buy(uint256 tokenId) public payable {\n', '        require(getApproved(tokenId) == address(this));\n', '        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);\n', '        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);\n', '        prices[tokenId].tokenOwner.transfer(msg.value);\n', '        resetPrice(tokenId);\n', '    }\n', '\n', '    function buyWithoutCheckApproved(uint256 tokenId) public payable {\n', '        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);\n', '        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);\n', '        prices[tokenId].tokenOwner.transfer(msg.value);\n', '        resetPrice(tokenId);\n', '    }\n', '\n', '    function resetPrice(uint256 tokenId) private {\n', '        prices[tokenId] = Price(address(0), 0, 0, 0, false);\n', '        for (uint8 i = 0; i < arrayTokenIdSale.length; i++) {\n', '            if (arrayTokenIdSale[i] == tokenId) {\n', '                _burnArrayTokenIdSale(i);\n', '            }\n', '        }\n', '    }\n', '}']