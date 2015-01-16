_ = require "underscore"
require "plus_arrays"
{ WORDNETIFY_SYNSETS_TREE }  = require "./Tree"

pickSynsets = (sentence) ->
  for word, index in sentence
    scores = []
    for synset in word
      similarities = []
      for word2, index2 in sentence
        if index != index2
          dists = word2.map (synset2) => WORDNETIFY_SYNSETS_TREE.jiangConrathSimilarity(synset.synsetid, synset2.synsetid)
          similarities.push(dists.max())
      synset.score = similarities.sum()
      scores.push(synset.score)
    maxScore = scores.max()
    chosen = false
    flaggedRemoval = []
    for synset, index in word
      if synset.score != maxScore or chosen == true
          flaggedRemoval.push(index)
      else
        chosen = true
    word.splice(i,1) for i in flaggedRemoval by -1
  sentence = sentence.map (synsets) => synsets[0]
  return sentence

module.exports = pickSynsets
