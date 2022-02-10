['pragma solidity ^0.5.8;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract IERC721 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20BasicInterface {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    uint8 public decimals;\n', '}\n', '\n', 'contract Bussiness is Ownable {\n', '    address public ceoAddress = address(0x6C3E879BDD20e9686cfD9BBD1bfD4B2Dd6d47079);\n', '    IERC721 public erc721Address = IERC721(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B);\n', '    ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);\n', '    uint256 public ETHFee = 25; // 2,5 %\n', '    uint256 public Percen = 1000;\n', '    uint256 public HBWALLETExchange = 21;\n', '    // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2\n', '    uint256 public limitETHFee = 2000000000000000;\n', '    uint256 public limitHBWALLETFee = 2;\n', '    uint256 public hightLightFee = 30000000000000000;\n', '    constructor() public {}\n', '    struct Price {\n', '        address payable tokenOwner;\n', '        uint256 price;\n', '        uint256 fee;\n', '        uint256 hbfee;\n', '        bool isHightlight;\n', '    }\n', '\n', '    uint[] public arrayTokenIdSale;\n', '    mapping(uint256 => Price) public prices;\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the ceo address.\n', '     */\n', '    modifier onlyCeoAddress() {\n', '        require(msg.sender == ceoAddress);\n', '        _;\n', '    }\n', '\n', '    // Move the last element to the deleted spot.\n', '    // Delete the last element, then correct the length.\n', '    function _burnArrayTokenIdSale(uint index) internal {\n', '        require(index < arrayTokenIdSale.length);\n', '        arrayTokenIdSale[index] = arrayTokenIdSale[arrayTokenIdSale.length - 1];\n', '        delete arrayTokenIdSale[arrayTokenIdSale.length - 1];\n', '        arrayTokenIdSale.length--;\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address){\n', '        return erc721Address.ownerOf(_tokenId);\n', '    }\n', '\n', '    function balanceOf() public view returns (uint256){\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getApproved(uint256 _tokenId) public view returns (address){\n', '        return erc721Address.getApproved(_tokenId);\n', '    }\n', '\n', '    function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {\n', '        prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);\n', '        arrayTokenIdSale.push(_tokenId);\n', '    }\n', '\n', '    function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public payable {\n', '        require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);\n', '        uint256 ethfee;\n', '        uint256 _hightLightFee = 0;\n', '        if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {\n', '            _hightLightFee = hightLightFee;\n', '        }\n', '        if (prices[_tokenId].price < _ethPrice) {\n', '            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;\n', '            if(prices[_tokenId].price == 0) {\n', '                if (ethfee >= limitETHFee) {\n', '                    require(msg.value == ethfee + hightLightFee);\n', '                } else {\n', '                    require(msg.value == limitETHFee + hightLightFee);\n', '                    ethfee = limitETHFee;\n', '                }\n', '            }\n', '            ethfee += prices[_tokenId].fee;\n', '        } else ethfee = _ethPrice * ETHFee / Percen;\n', '\n', '        setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight);\n', '    }\n', '\n', '    function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public returns (bool){\n', '        require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);\n', '        uint256 fee;\n', '        uint256 ethfee;\n', '        uint256 _hightLightFee = 0;\n', '        if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {\n', '            _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);\n', '        }\n', '        if (prices[_tokenId].price < _ethPrice) {\n', '            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;\n', '            fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);\n', '            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)\n', '            if(prices[_tokenId].price == 0) {\n', '                if (fee >= limitHBWALLETFee) {\n', '                    require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));\n', '                } else {\n', '                    require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));\n', '                    fee = limitHBWALLETFee;\n', '                }\n', '            }\n', '            fee += prices[_tokenId].hbfee;\n', '        } else {\n', '            ethfee = _ethPrice * ETHFee / Percen;\n', '            fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);\n', '        }\n', '\n', '        setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight);\n', '        return true;\n', '    }\n', '\n', '    function removePrice(uint256 tokenId) public returns (uint256){\n', '        require(erc721Address.ownerOf(tokenId) == msg.sender);\n', '        if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);\n', '        else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);\n', '        resetPrice(tokenId);\n', '        return prices[tokenId].price;\n', '    }\n', '\n', '    function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){\n', '        require(_ethFee > 0 && _HBWALLETExchange > 0 && _hightLightFee > 0);\n', '        ETHFee = _ethFee;\n', '        HBWALLETExchange = _HBWALLETExchange;\n', '        hightLightFee = _hightLightFee;\n', '        return (ETHFee, HBWALLETExchange, hightLightFee);\n', '    }\n', '\n', '    function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){\n', '        require(_ethlimitFee > 0 && _hbWalletlimitFee > 0);\n', '        limitETHFee = _ethlimitFee;\n', '        limitHBWALLETFee = _hbWalletlimitFee;\n', '        return (limitETHFee, limitHBWALLETFee);\n', '    }\n', '    /**\n', '     * @dev Withdraw the amount of eth that is remaining in this contract.\n', '     * @param _address The address of EOA that can receive token from this contract.\n', '     */\n', '    function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {\n', '        require(_address != address(0) && amount > 0 && address(this).balance >= amount && _amountHB > 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);\n', '        _address.transfer(amount);\n', '        hbwalletToken.transferFrom(address(this), _address, _amountHB);\n', '    }\n', '\n', '    function cancelBussiness() public onlyCeoAddress {\n', '        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {\n', '            if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {\n', '                if (prices[arrayTokenIdSale[i]].fee > 0 && address(this).balance >= prices[arrayTokenIdSale[i]].fee) {\n', '                    prices[arrayTokenIdSale[i]].tokenOwner.transfer(prices[arrayTokenIdSale[i]].fee);\n', '                }\n', '                else if (prices[arrayTokenIdSale[i]].hbfee > 0 && hbwalletToken.balanceOf(address(this)) >= prices[arrayTokenIdSale[i]].hbfee) {\n', '                    hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, prices[arrayTokenIdSale[i]].hbfee);\n', '                }\n', '            }\n', '            resetPrice(arrayTokenIdSale[i]);\n', '        }\n', '    }\n', '\n', '    function changeCeo(address _address) public onlyCeoAddress {\n', '        require(_address != address(0));\n', '        ceoAddress = _address;\n', '\n', '    }\n', '\n', '    function buy(uint256 tokenId) public payable {\n', '        require(getApproved(tokenId) == address(this));\n', '        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);\n', '        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);\n', '        prices[tokenId].tokenOwner.transfer(msg.value);\n', '        resetPrice(tokenId);\n', '    }\n', '\n', '    function buyWithoutCheckApproved(uint256 tokenId) public payable {\n', '        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);\n', '        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);\n', '        prices[tokenId].tokenOwner.transfer(msg.value);\n', '        resetPrice(tokenId);\n', '    }\n', '\n', '    function resetPrice(uint256 tokenId) private {\n', '        prices[tokenId] = Price(address(0), 0, 0, 0, false);\n', '        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {\n', '            if (arrayTokenIdSale[i] == tokenId) {\n', '                _burnArrayTokenIdSale(i);\n', '            }\n', '        }\n', '    }\n', '}']