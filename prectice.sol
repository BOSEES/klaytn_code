// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

contract Practice {
    string public name = "klayman";
    string public symbol = "KLM";
    
    mapping (uint256 => address) public tokenOwner;
    mapping (uint256 => string) public tokenUrl;
    mapping (address => uint256[]) private _ownedTokenList;
    
    function mintToken(uint256 tokenId,string memory url) public {
        tokenOwner[tokenId] = msg.sender;
        tokenUrl[tokenId] = url;
        _ownedTokenList[msg.sender].push(tokenId);
    }
    
    function safeTransferFrom(uint256 tokenId, address to) public {
        require(tokenOwner[tokenId] == msg.sender);
        tokenOwner[tokenId] = to;
        _ownedTokenList[to].push(tokenId);
        _removeTokenList(msg.sender, tokenId);
    }
    
    function ownedTokenListView(address owner) public view returns (uint256[] memory){
        return _ownedTokenList[owner];
    }
    
    function setUrl(uint256 id, string memory url) public {
        tokenUrl[id] = url;
    }
    
    function _removeTokenList(address target, uint256 tokenId) private {
        for(uint i = 0; i < _ownedTokenList[target].length; i++) {
            if(tokenId == _ownedTokenList[target][i]) {
                uint256 lastToken = _ownedTokenList[target][_ownedTokenList[target].length - 1];
                _ownedTokenList[target][i] = lastToken;
                break;
            }
        }
        _ownedTokenList[target].pop();
    }  
}