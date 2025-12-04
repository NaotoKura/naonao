import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = { laneId: Number }

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: 'kanban', // レーン間でカードを移動できるようにグループ名を統一
      animation: 150,
      onEnd: this.onEnd.bind(this),
    });
  }

  async onEnd(event) {
    const { item, to, newIndex } = event;
    const cardId = item.dataset.cardId;
    // 移動先のlaneIdは、移動先の要素の`data-drag-lane-id-value`から取得
    const laneId = to.closest('[data-controller="drag"]').dataset.dragLaneIdValue;

    const url = `/cards/${cardId}/move`;
    const body = {
      lane_id: laneId,
      position: newIndex + 1, // 0-indexedから1-indexedに変換
    };

    // サーバーにカードの位置情報を送信
    await patch(url, { body: JSON.stringify(body) });
  }
}
